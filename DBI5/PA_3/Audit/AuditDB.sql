DROP TABLE emp_log;
DROP TABLE emp;

CREATE TABLE emp (
	id number not NULL,
	name varchar2(50),
	job varchar2(50),
	sal number not null,
	constraint emp_pk primary key (id)
);

INSERT INTO emp VALUES (1, 'Alex' , 'CEO'    ,150000 );
INSERT INTO emp VALUES (2, 'Klaus', 'Sr RnD' , 75000 );
INSERT INTO emp VALUES (3, 'Rudi' , 'Jr RnD' , 55000 );
INSERT INTO emp VALUES (4, 'Berta', 'Manager', 90000 );
INSERT INTO emp VALUES (5, 'Fritz', 'Dev'    , 60000 );

create table emp_log (
   empno    number,
   log_text varchar2(400),
   log_date date
);

-- testing

DROP TRIGGER sal_audit_1;
DROP TRIGGER sal_audit_2;
DROP TRIGGER sal_audit_3_stmt;
DROP TRIGGER sal_audit_3;
-- DROP TRIGGER sal_audit_4;

-- test step 3
UPDATE emp SET sal = 170000 WHERE id = 2; 

Select * from emp_log; -- Überprüfen der Log-Einträge
select * from emp; -- Überprüfen der Gehälter in der emp Tabelle