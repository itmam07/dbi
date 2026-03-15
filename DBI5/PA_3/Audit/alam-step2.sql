-- step 2 - get max salary from table, but this will cause mutating table error

CREATE OR REPLACE TRIGGER sal_audit_2
BEFORE UPDATE OF sal ON emp
FOR EACH ROW
DECLARE
    v_max_sal number;
BEGIN

    -- get max salary wont work because of mutating table error!
    select max(sal) into v_max_sal from emp;

    IF :new.sal <= v_max_sal THEN
        INSERT INTO emp_log (empno, log_text, log_date) VALUES
        (:new.id, 'Gehalt Update Erfolgreich - altes Gehalt: ' || :old.sal || ', neues Gehalt: ' || :new.sal, sysdate);
    ELSE
        INSERT INTO emp_log (empno, log_text, log_date) VALUES
        (:new.id, 'Gehalt nicht geändert - kann nicht mehr als ' || v_max_sal || ' sein.', sysdate);
        :new.sal := :old.sal; -- Verhindert die Aktualisierung des Gehalts
    END IF;
END;
/

commit;