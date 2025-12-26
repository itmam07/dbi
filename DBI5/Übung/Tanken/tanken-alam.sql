-- 1. Functions

create or replace function preisaenderung_fun
(
    preis_alt number,
    preis_neu number
) return number
is
begin
    return round((preis_neu / preis_alt - 1) * 100, 3);
end;
/

select preisaenderung_fun(110, 100) from dual;

create or replace function angebot_fun
return number
is
    v_kraftstoff_count number;
    v_zapf_count number;
begin
    select count(*)
    into v_kraftstoff_count
    from kraftstoff;

    select count(*)
    into v_zapf_count
    from
    (
        select ZapfsauleNr
        from zapfsaule_kraftstoff
        group by ZapfsauleNr
        having count(Kraftstoffname) = v_kraftstoff_count
    );

    return v_zapf_count;
end;
/

select angebot_fun() from dual;

-- 2. Procedures

create or replace procedure Preisentwicklung_api
(
    i_vonDatum in date,
    i_bisDatum in date
)
as
    cursor kraftstoff_cursor is
    select Kraftstoffname
    from Kraftstoff;

    v_previous_preis number := 0;
begin
    dbms_output.put_line('Kraftstoff  ' || '   Tag   ' || '   Tagespreis' || '   Veränderung');

    for k in kraftstoff_cursor loop
        dbms_output.put_line(k.Kraftstoffname);

        for t in 
            (select * 
             from tagespreis 
             where kraftstoffname = k.Kraftstoffname
                and tagesdatum between i_vonDatum and i_bisDatum
             order by Tagesdatum asc) loop
            if (v_previous_preis = 0) then
                dbms_output.put_line('            ' || TO_CHAR(t.Tagesdatum, 'DD.MM.YYYY') || '      ' || t.Preis);
            else
                dbms_output.put_line('            ' || TO_CHAR(t.Tagesdatum, 'DD.MM.YYYY') || '      ' || t.Preis || '      ' || preisaenderung_fun(v_previous_preis, t.Preis) || ' %');
            end if;
            v_previous_preis := t.Preis;
        end loop;
        v_previous_preis := 0;
    end loop;
end;
/

exec Preisentwicklung_api(TO_DATE('14.12.2025', 'DD.MM.YYYY'), TO_DATE('18.12.2025', 'DD.MM.YYYY'));

create or replace procedure Tanken_api
(
    i_ZapfsauleNr in number,
    i_Kraftstoffname in varchar2,
    i_Anzahl in number
)
as
    v_kap number;
    v_aktMenge number;
    v_random_menge number;
    v_next_entnahmeNr number;
begin
    -- check if zapf and fuel exist
    select maxKapazitaet, aktMenge
    into v_kap, v_aktMenge
    from Zapfsaule_Kraftstoff
    where ZapfsauleNr = i_ZapfsauleNr
      and Kraftstoffname = i_Kraftstoffname; 

    if (v_kap is null) then
        raise_application_error(-20001, 'Die Zapfsäule führt den Kraftstoff nicht.');
    end if;

    for i in 1..i_Anzahl loop
        -- check if current amount is sufficient
        select aktMenge
        into v_aktMenge
        from Zapfsaule_Kraftstoff
        where ZapfsauleNr = i_ZapfsauleNr
          and Kraftstoffname = i_Kraftstoffname;

        v_random_menge := round(dbms_random.value(10, 120), 0);
        
        if (v_aktMenge - v_random_menge < 0) then
            raise_application_error(-20002, 'Nicht genügend Kraftstoff an der Zapfsäule.');
        end if;

        -- fill next entnahme and update current amount
        select nvl(max(EntnahmeNr), 0) + 1
        into v_next_entnahmeNr
        from Entnahme;

        insert into Entnahme (EntnahmeNr, Menge, Kraftstoffname, ZapfsauleNr)
        values (v_next_entnahmeNr, v_random_menge, i_Kraftstoffname, i_ZapfsauleNr);

        update Zapfsaule_Kraftstoff
        set aktMenge = aktMenge - v_random_menge
        where ZapfsauleNr = i_ZapfsauleNr
            and Kraftstoffname = i_Kraftstoffname;
    end loop;
end;
/

exec Tanken_api(101, 'Super 95', 15);
select * from Zapfsaule_Kraftstoff where ZapfsauleNr = 101 and Kraftstoffname = 'Super 95';
select * from Entnahme;
