-- step 1 - simple trigger with hardcoded max salary

CREATE OR REPLACE TRIGGER sal_audit_1
BEFORE UPDATE OF sal ON emp
FOR EACH ROW
BEGIN
    IF :new.sal <= 100000 THEN
        INSERT INTO emp_log (empno, log_text, log_date) VALUES
        (:new.id, 'Gehalt Update Erfolgreich - altes Gehalt: ' || :old.sal || ', neues Gehalt: ' || :new.sal, sysdate);
    ELSE
        INSERT INTO emp_log (empno, log_text, log_date) VALUES
        (:new.id, 'Gehalt nicht geändert - kann nicht mehr als 100000 sein.', sysdate);
        :new.sal := :old.sal; -- Verhindert die Aktualisierung des Gehalts
    END IF;
END;
/

commit;