create or replace function preisaenderung_fun
(
    alterPreis number,
    neuerPreis number
) return varchar2 
is 
    v_number number;
begin
    v_number := round((neuerPreis / alterPreis - 1) * 100, 3);
    if v_number > 0 then
        return '+' || to_char(v_number) || '%';
    else
        return to_char(v_number) || '%';
    end if;
end;
/ 

select preisaenderung_fun(110, 100) from dual;

create or replace function angebot_fun 
return number 
is
    v_anzahl number;
begin
    SELECT COUNT(*)
    INTO v_anzahl
    from (
        select ZapfsauleNr
        FROM Zapfsaule_Kraftstoff
        GROUP BY ZapfsauleNr
        HAVING COUNT(DISTINCT Kraftstoffname) =
           (SELECT COUNT(*) FROM Kraftstoff)
    );

    RETURN v_anzahl;
end;
/

select angebot_fun() from dual;

create or replace procedure Preisentwicklung_api
(
    i_vonDatum in date,
    i_bisDatum in date
)
as
    v_previous number := 0;
    v_skip_line number := 0;
begin
    dbms_output.put_line('Kraftstoff   ' || '   Tag   ' || '   Tagespreis' || '   Veränderung');
    for k in (select Kraftstoffname from Kraftstoff) loop 
        dbms_output.put_line(k.Kraftstoffname);
        for t in 
        (
            select * 
            from Tagespreis 
            where Kraftstoffname = k.Kraftstoffname
              and Tagesdatum between i_vonDatum and i_bisDatum
        ) loop
            if v_skip_line = 0 then
                dbms_output.put_line('             ' || to_char(t.Tagesdatum, 'DD.MM.YYYY') || '    ' || t.Preis ); 
                v_skip_line := 1;
            else
                dbms_output.put_line('             ' || to_char(t.Tagesdatum, 'DD.MM.YYYY') || '    ' || t.Preis || '       ' || preisaenderung_fun(v_previous, t.Preis) || '%');
            end if;
            v_previous := t.Preis;
        end loop;
        v_skip_line := 0;
    end loop;
end;
/

call PREISENTWICKLUNG_API(to_date('12.12.2025', 'DD.MM.YYYY'), to_date('18.12.2025', 'DD.MM.YYYY'));