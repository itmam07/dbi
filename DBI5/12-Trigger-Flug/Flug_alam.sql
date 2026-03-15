-- 1) Primärschlüssel dürfen nicht geändert werden
CREATE OR REPLACE TRIGGER trg_no_pk_change_pilot
BEFORE UPDATE OF PNr ON Pilot
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20001,'Primärschlüssel darf nicht geändert werden');
END;
/

CREATE OR REPLACE TRIGGER trg_no_pk_change_typ
BEFORE UPDATE OF TNr ON Typ
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20002,'Primärschlüssel darf nicht geändert werden');
END;
/

CREATE OR REPLACE TRIGGER trg_no_pk_change_flugzeug
BEFORE UPDATE OF FZNr ON Flugzeug
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20003,'Primärschlüssel darf nicht geändert werden');
END;
/


-- 2) Maximal 3 Schulungen pro Pilot
CREATE OR REPLACE TRIGGER trg_max3_geschult
BEFORE INSERT ON geschult
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM geschult
    WHERE Pilot_PNr = :NEW.Pilot_PNr;

    IF v_count >= 3 THEN
        RAISE_APPLICATION_ERROR(-20010,'Ein Pilot darf nur 3 Typen lernen');
    END IF;
END;
/


-- 3) Änderungsdatum und User beim Pilot speichern
CREATE OR REPLACE TRIGGER trg_pilot_mod
BEFORE UPDATE ON Pilot
FOR EACH ROW
BEGIN
    :NEW.ModDat := SYSDATE;
    :NEW.ModUser := USER;
END;
/


-- 4) Nur geschulte Piloten dürfen ein Flugzeug fliegen
CREATE OR REPLACE TRIGGER trg_check_pilot_typ
BEFORE INSERT OR UPDATE ON Flug
FOR EACH ROW
DECLARE
    v_typ NUMBER;
    v_count NUMBER;
BEGIN
    -- Flugzeugtyp holen
    SELECT TNr INTO v_typ
    FROM Flugzeug
    WHERE FZNr = :NEW.FZNr;

    -- Prüfen ob Pilot dafür geschult ist
    SELECT COUNT(*) INTO v_count
    FROM geschult
    WHERE Pilot_PNr = :NEW.PNr
    AND Typ_TNr = v_typ;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20020,'Pilot ist nicht für diesen Flugzeugtyp geschult');
    END IF;
END;
/


-- 5) Flugstunden automatisch berechnen
CREATE OR REPLACE TRIGGER trg_update_flugstunden
AFTER INSERT OR UPDATE OF Ankunft ON Flug
FOR EACH ROW
DECLARE
    v_dauer INTERVAL DAY TO SECOND;
BEGIN
    IF :NEW.Ankunft IS NOT NULL THEN

        v_dauer := :NEW.Ankunft - :NEW.Abflug;

        UPDATE Flugzeug
        SET Flugstunden = Flugstunden + v_dauer
        WHERE FZNr = :NEW.FZNr;

    END IF;
END;
/