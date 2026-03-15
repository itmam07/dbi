-- step 3 - package variable

create or replace package emp_pkg is
   g_max_sal emp.sal%type;
end emp_pkg;
/

create or replace package body emp_pkg is end emp_pkg;
/

-- trigger on package variable to update the max salary
create or replace trigger sal_audit_3_stmt
before update of sal on emp
begin
   select max(sal)
     into emp_pkg.g_max_sal
     from emp;
end;
/

CREATE OR REPLACE TRIGGER sal_audit_3
BEFORE UPDATE OF sal ON emp
FOR EACH ROW
BEGIN
    -- use the package variable instead of querying the table
    IF :new.sal <= emp_pkg.g_max_sal THEN
        INSERT INTO emp_log (empno, log_text, log_date)
        VALUES (
            :new.id,
            'Gehalt Update Erfolgreich - altes Gehalt: ' ||
            :old.sal || ', neues Gehalt: ' || :new.sal,
            sysdate
        );
    ELSE
        INSERT INTO emp_log (empno, log_text, log_date)
        VALUES (
            :new.id,
            'Gehalt nicht geändert - kann nicht mehr als ' ||
            emp_pkg.g_max_sal || ' sein.',
            sysdate
        );

        :new.sal := :old.sal;
    END IF;
END;
/

commit;