-- step 4 - compound trigger

CREATE OR REPLACE TRIGGER sal_audit_4
FOR UPDATE OF sal ON emp
COMPOUND TRIGGER

    -- Variable, um höchsten SAL vor dem Update zu speichern
    g_max_sal NUMBER;

    BEFORE STATEMENT IS
    BEGIN
        SELECT MAX(sal)
          INTO g_max_sal
          FROM emp;
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        IF :new.sal <= g_max_sal THEN
            INSERT INTO emp_log (empno, log_text, log_date)
            VALUES (
                :new.id,
                'Gehalt Update Erfolgreich - altes Gehalt: ' || :old.sal || ', neues Gehalt: ' || :new.sal,
                SYSDATE
            );
        ELSE
            INSERT INTO emp_log (empno, log_text, log_date)
            VALUES (
                :new.id,
                'Gehalt nicht geändert - kann nicht mehr als ' || g_max_sal || ' sein.',
                SYSDATE
            );

            :new.sal := :old.sal; -- verhindert Aktualisierung
        END IF;
    END BEFORE EACH ROW;

END sal_audit_4;
/

commit;