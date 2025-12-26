-- author: Itmam Alam
-- date: 25.11.2025

create or replace procedure loading
(
    i_prodnr product.prodnr%type,
    i_delivery_date delivery.delivery_date%type,
    i_number integer
)
as
   used_capacity number;
   max_capacity number;
   remaining_amount number := i_number;
   free_capacity number;
   next_serial number;

   cursor stock_cursor is
   select * from stock;
begin

   select sum(capacity) 
   into max_capacity 
   from stock;

   select sum(amount) 
   into used_capacity 
   from delivery;
   
   if (max_capacity - used_capacity) < i_number then
      raise_application_error(-20001, 'Missing capacity by ' || (i_number - (max_capacity - used_capacity)));
   end if;

   for stock_row in stock_cursor loop
      select sum(amount)
      into used_capacity
      from delivery
      where stocknr = stock_row.stocknr;

      free_capacity := stock_row.capacity - nvl(used_capacity,0);
      
      dbms_output.put_line('Free capacity in stock ' || stock_row.stocknr || ' is ' || nvl(free_capacity,0));

      if free_capacity <= i_number then
         dbms_output.put_line('Filling stock ' || stock_row.stocknr || ' with ' || free_capacity || ' units.');
         dbms_output.put_line('Stock ' || stock_row.stocknr || ' is now full.');

         select nvl(max(serial_nr),0) + 1
         into next_serial
         from delivery
         where stocknr = stock_row.stocknr;

         insert into delivery values(stock_row.stocknr, next_serial, i_prodnr, i_delivery_date, free_capacity);

         remaining_amount := remaining_amount - free_capacity;
         dbms_output.put_line('Remaining amount to allocate: ' || remaining_amount);
      else
         dbms_output.put_line('Filling stock ' || stock_row.stocknr || ' with ' || remaining_amount || ' units.');

         select nvl(max(serial_nr),0) + 1
         into next_serial
         from delivery
         where stocknr = stock_row.stocknr;

         insert into delivery values(stock_row.stocknr, next_serial, i_prodnr, i_delivery_date, remaining_amount);

         remaining_amount := 0;
         exit;
      end if;
   end loop;
end;
/

call loading(1, to_date('2025-11-25', 'YYYY.MM.DD'), 40);

select * from delivery;


CREATE OR REPLACE PROCEDURE unloading(
    i_prodnr IN product.prodnr%TYPE,
    i_number IN INTEGER
)
AS
    v_remaining NUMBER := i_number;  -- Was noch entladen werden muss
    v_total     NUMBER;              -- Gesamtanzahl der verfügbaren Teile
BEGIN
    -- 1) Prüfen, ob genug Produkte vorhanden sind
    SELECT SUM(amount)
    INTO v_total
    FROM delivery
    WHERE prodnr = i_prodnr;

    IF v_total < i_number THEN
        raise_application_error(-20010,
            'Not enough products to unload. Missing ' || (i_number - v_total));
    END IF;

    -- 2) Entladen: Älteste Lieferungen zuerst
    FOR d IN (
        SELECT stocknr, serial_nr, amount
        FROM delivery
        WHERE prodnr = i_prodnr
        ORDER BY delivery_date ASC
    ) LOOP
        EXIT WHEN v_remaining = 0;

        -- Wieviel können wir aus dieser Lieferung entladen?
        DECLARE
            v_take NUMBER;
        BEGIN
            v_take := LEAST(d.amount, v_remaining);

            -- Fall 1: komplette Lieferung löschen
            IF v_take = d.amount THEN
                DELETE FROM delivery
                WHERE serial_nr = d.serial_nr;
            -- Fall 2: nur die Menge reduzieren
            ELSE
                UPDATE delivery
                SET amount = amount - v_take
                WHERE serial_nr = d.serial_nr;
            END IF;

            DBMS_OUTPUT.PUT_LINE('Unloaded ' || v_take ||
                                 ' items from stock ' || d.stocknr);

            v_remaining := v_remaining - v_take;
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('=> Unloading completed.');
END;
/

call unloading(1, 300);

select * from delivery;