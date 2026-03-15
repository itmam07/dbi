set define off;

create or replace trigger pk_pilot
before update on pilot
for each row 
begin
    if :old.pnr != :new.pnr then
        raise_application_error(-20001, 'Pk cannot be changed on pilot!');
    end if;
end;
/
show errors

create or replace trigger pk_typ
before update on typ
for each row 
begin
    if :old.tnr != :new.tnr then
        raise_application_error(-20001, 'Pk cannot be changed on typ!');
    end if;
end;
/
show errors

create or replace trigger pk_flugzeug
before update on flugzeug
for each row 
begin
    if :old.fznr != :new.fznr then
        raise_application_error(-20001, 'Pk cannot be changed on flugzeug!');
    end if;
end;
/
show errors

create or replace trigger pk_flug
before update on flug
for each row 
begin
    if :old.fnr != :new.fnr or :old.abflug != :new.abflug then
        raise_application_error(-20001, 'Pk cannot be changed on flug!');
    end if;
end;
/
show errors

-----------------

create or replace trigger max3_geschult
before insert
on geschult
for each row
declare
    v_count number := 0;
begin
    select count(*) into v_count
    from geschult
    where PILOT_PNR = :new.PILOT_PNR;

    if (v_count >= 3) then
        raise_application_error(-20002, 'A pilot can only be trained for 3 types of aircraft!');
    end if;
end;
/
show errors

-----------------

create or replace trigger pilot_mod
before insert or update 
on pilot
for each row
BEGIN
    :NEW.ModDat := SYSDATE;
    :NEW.ModUser := USER;
end;
/

-----------------

create or replace trigger flug_only_geschult_pilot
before insert or update
on flug
for each row
declare
    v_flug_tnr number;
    v_count number;
BEGIN
    select tnr into v_flug_tnr
    from flugzeug
    where FZNR = :new.FZNR;

    select count(*) into v_count
    from GESCHULT
    where PILOT_PNR = :new.PNR and TYP_TNR = v_flug_tnr;

    if v_count = 0 then
       raise_application_error(-20003, 'Only pilots who are trained for this type of aircraft can be assigned to this flight!');
    end if;
end;
/
show errors

-----------------

create or replace trigger flugzeug_log_stunden
after insert or update or delete
on flug
for each row
declare
    v_duration interval day to second;
begin
    -- addiere stunden zur flugzeit
    if inserting then
        if :new.Ankunft is not null and :new.Abflug < :new.Ankunft then
            v_duration := :new.Ankunft - :new.Abflug;
            update flugzeug
            set Flugstunden = Flugstunden + v_duration
            where FZNr = :new.FZNr;
        end if;
    end if;

    -- alte stunden subtrahieren, neue stunden addieren
    if updating then
        if :old.Ankunft is not null then
            v_duration := :old.Ankunft - :old.Abflug;
            update flugzeug
            set Flugstunden = Flugstunden - v_duration
            where FZNr = :new.FZNr;
        end if;
        if :new.Ankunft is not null and :new.Abflug < :new.Ankunft then
            v_duration := :new.Ankunft - :new.Abflug;
            update flugzeug
            set Flugstunden = Flugstunden + v_duration
            where FZNr = :new.FZNr;
        end if;
    end if;

    -- flugstunden subtrahieren
    if deleting then 
        v_duration := :old.Ankunft - :old.Abflug;
        update flugzeug
        set Flugstunden = Flugstunden - v_duration
        where FZNr = :old.FZNr;
    end if;
end;
/
show errors