CREATE OR REPLACE PROCEDURE loading 
(
    i_prodnr product.prodnr%TYPE,
    i_delivery_date delivery.delivery_date%TYPE,
    i_number INTEGER
)
AS
    v_capacity NUMBER;
    v_used_capacity NUMBER;
    v_free_capacity NUMBER;
    v_left NUMBER := i_number;
    v_next_serial NUMBER := 0;
    v_load NUMBER;
BEGIN
    select sum(capacity) into v_capacity 
    from stock;

    select sum(amount) into v_used_capacity
    from delivery;
    v_free_capacity := v_capacity - v_used_capacity;

    if (v_free_capacity) < i_number then
        raise_application_error(-20001, 'Capacity to low');
    end if; 

    for i in (select stocknr from stock) loop
        exit when v_left = 0;

        select sum(capacity) into v_capacity 
        from stock
        where stocknr = i.stocknr;

        select nvl(sum(amount), 0) into v_used_capacity
        from delivery
        where stocknr = i.stocknr;

        v_free_capacity := v_capacity - v_used_capacity;
        dbms_output.put_line('Free capacity in stock ' || i.stocknr || ' is ' || nvl(v_free_capacity,0));

        select nvl(max(serial_nr), 0) + 1 
        into v_next_serial
        from delivery
        where stocknr = i.stocknr;
        v_load := least(v_free_capacity, v_left);

        insert into delivery(stocknr, serial_nr, prodnr, delivery_date, amount)
        values (i.stocknr, v_next_serial, i_prodnr, i_delivery_date, v_load);

        v_left := v_left - v_load;
        dbms_output.put_line('Delivered ' || v_load || ' pcs into stock ' || i.stocknr || '. ' || v_left || ' pcs left.');
    end loop;

    dbms_output.put_line('Done.');
END;
/

exec loading(1, sysdate, 500);

select * from delivery;

create or replace procedure unloading 
(
    i_prodnr product.prodnr%type,
    i_number integer
)
as
    v_total integer;
    v_remaining integer := i_number;

    cursor product_cursor is
        select *
        from delivery
        where prodnr = i_prodnr
        order by delivery_date asc;
begin
    select nvl(sum(amount), 0)
    into v_total
    from delivery
    where prodnr = i_prodnr;

    if (v_total < i_number) then
        raise_application_error(-20001, 'Cannot unload ' ||  i_number || ' pcs of Product ' || i_prodnr);
    end if;

    for r in product_cursor loop
        exit when v_remaining = 0;

        if r.amount <= v_remaining then
            dbms_output.put_line('Deleting delivery with ' || r.amount || ' pcs');
            
            delete from delivery
            where stocknr = r.stocknr and serial_nr = r.serial_nr;
            
            v_remaining := v_remaining - r.amount;
            dbms_output.put_line(v_remaining || ' pcs remaining to unload');
        else
            dbms_output.put_line('Modifying delivery');
            
            update delivery
            set amount = amount - v_remaining
            where stocknr = r.stocknr and serial_nr = r.serial_nr;

            v_remaining := 0;
            dbms_output.put_line(v_remaining || ' pcs remaining to unload');
        end if;
    end loop;
end;
/

exec unloading(1, -2);


create or replace function get_free_capacity 
(
    i_stocknr stock.stocknr%type
)
RETURN number
is
    v_capacity number;
    v_used_capacity number;
begin
    select nvl(capacity, 0) into v_capacity
    from stock
    where stocknr = i_stocknr;

    select nvl(sum(amount), 0) into v_used_capacity
    from delivery
    where stocknr = i_stocknr;

    return v_capacity - v_used_capacity;
end;
/

select get_free_capacity(3) from dual;

create or replace function get_product_quantity
(
    i_prodnr product.prodnr%TYPE
) return number is
    v_count number;
    v_quantity number;
begin

    select COUNT(*) INTO v_count 
    from product 
    where prodnr = i_prodnr;

    if v_count = 0 then
        raise_application_error(-20001, 'Product does not exist');
    end if;

    select nvl(sum(amount), 0) into v_quantity
    from delivery
    where prodnr = i_prodnr;

    return v_quantity; 
end;
/

select get_product_quantity(6) from dual;
