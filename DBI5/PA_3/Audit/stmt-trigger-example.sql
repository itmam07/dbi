--- Std mässig ist ein Trigger in Oracle ein Statement Level Trigger - wird nur einmal aufgerufen, old/new nicht verwendbar
--- erst die Verwendung von FOR EACH ROW macht ihn zu einem Row-Level Trigger - pro Zeile aufgerufen, old/new verwendbar 
--- Aufgabe: Audit von Änderungen, im konkreten Löschungen, von Zeilen der Tabelle emp
--- Überlegung: uns interessieren nicht die konkreten Daten, nur das Energebnis bzw. die Anzahl der Zeilen nach erfolgter Änderungen
--- Lösung: after delete statement trigger 

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

CREATE TABLE emp_count (
	username varchar2(100),
	created_on date,
	row_count number
);

--- Startwert selber einfügen
SET SERVEROUTPUT ON;
DECLARE
v_rowcnt number := 0;
BEGIN
SELECT count(*) INTO v_rowcnt FROM emp;
INSERT INTO emp_count VALUES ('INIT',sysdate,v_rowcnt);
END;
/

--- Audit Trigger erstellen
--- Speichere welcher User welche Änderung an der Tabelle emp gemacht hat
CREATE OR REPLACE TRIGGER AD_EMP
AFTER DELETE ON emp
DECLARE
	v_rowcnt number := 0;
	usr varchar2(50);
BEGIN
	--- berechne aktuelle zeilenanzahl
	SELECT count(*) INTO v_rowcnt FROM emp;
	--- besorge aktuellen user der die Änderung gemacht hat
	SELECT user INTO usr from dual;
	--- füge infos in die Audit Tabelle ein
	INSERT INTO emp_count VALUES (usr,sysdate, v_rowcnt);
END;

--- Zeilen löschen - alle geraden IDs => 2 Zeile von den 5 werden gelöscht
DELETE FROM emp WHERE MOD(id,2)=0;

--- checken ob Audit erfolgt ist - 3 sollten noch da sein
SELECT * FROM emp_count;

