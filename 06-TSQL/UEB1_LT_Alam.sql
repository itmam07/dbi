/*
 * author: Itmam Alam
 * file: UEB1_LT_Alam.sql
*/

Drop procedure if exists del_l;
go
Drop procedure if exists del_t;
go
Drop procedure if exists inc_by_percent;
go
DROP TABLE if exists lt
go
DROP TABLE if exists l
go
DROP TABLE if exists t
go

---------------------------------------------------------
-- Tabelle der Lieferanten
---------------------------------------------------------
CREATE TABLE l (
       lnr    CHAR(2) PRIMARY KEY,
       lname  VARCHAR(6),
       rabatt DECIMAL(2),
       stadt  VARCHAR(6))
go

---------------------------------------------------------
-- Tabelle der Teile
---------------------------------------------------------
CREATE TABLE t (
       tnr    CHAR(2) PRIMARY KEY,
       tname  VARCHAR(8),
       farbe  VARCHAR(5),
       preis  DECIMAL(10,2),
       stadt  VARCHAR(6))
go

---------------------------------------------------------
-- Tabelle der Lieferungen
---------------------------------------------------------
CREATE TABLE lt (
       lnr    CHAR(2) REFERENCES l,
       tnr    CHAR(2) REFERENCES t,
       menge  DECIMAL(4),
       PRIMARY KEY (lnr,tnr))
go

INSERT INTO l VALUES ('L1','Schmid',20,'London')
INSERT INTO l VALUES ('L2','Jonas', 10,'Paris' )
INSERT INTO l VALUES ('L3','Berger',30,'Paris' )
INSERT INTO l VALUES ('L4','Klein', 20,'London')
INSERT INTO l VALUES ('L5','Adam',  30,'Athen' )
go
INSERT INTO t VALUES ('T1','Mutter',  'rot',  12,'London')
INSERT INTO t VALUES ('T2','Bolzen',  'gelb', 17,'Paris' )
INSERT INTO t VALUES ('T3','Schraube','blau', 17,'Rom'   )
INSERT INTO t VALUES ('T4','Schraube','rot',  14,'London')
INSERT INTO t VALUES ('T5','Welle',   'blau', 12,'Paris' )
INSERT INTO t VALUES ('T6','Zahnrad', 'rot',  19,'London')
go
INSERT INTO lt VALUES ('L1','T1',300)
INSERT INTO lt VALUES ('L1','T2',200)
INSERT INTO lt VALUES ('L1','T3',400)
INSERT INTO lt VALUES ('L1','T4',200)
INSERT INTO lt VALUES ('L1','T5',100)
INSERT INTO lt VALUES ('L1','T6',100)
INSERT INTO lt VALUES ('L2','T1',300)
INSERT INTO lt VALUES ('L2','T2',400)
INSERT INTO lt VALUES ('L3','T2',200)
INSERT INTO lt VALUES ('L4','T2',200)
INSERT INTO lt VALUES ('L4','T4',300)
INSERT INTO lt VALUES ('L4','T5',400)
go

-- select * from l;
-- select * from t;
-- select * from lt;

--------------------------------------------------------------
--------------------------------------------------------------
-- Die Verwendung von IF 
-- Wenn die Anzahl der Teile am Lager 'L1' größer als 10 ist, dann Meldung ausgeben,
-- sonst von jedem Teil am Lager 'L1' Name des Teils, Farbe, Menge ausgeben

if (Select SUM(menge) From lt Where lnr = 'L1') > 10
	print 'Teileanzahl am Lager L1 > 10';
else
	begin
		Select t.tname, t.farbe, lt.menge 
		From lt
		Left Join t on lt.tnr = t.tnr
		Where lt.lnr = 'L1';
	end
go

--------------------------------------------------------------
--------------------------------------------------------------
-- Die while Anweisung
-- Solange die Summe der Menge aller Artikel im Lager kleiner als 10000 ist,
-- soll die Menge um 10 % erhöht werden. 
-- Wenn jedoch der Maximalwert der Menge eines Teiles größer als 500 ist,
-- soll abgebrochen werden

while (Select SUM(menge) From lt) < 10000
	begin
		if exists (Select tnr From lt Where menge > 500)
			break;
		Update lt
		Set menge = menge * 1.10;
	end
go

----------------------------------------------------------
----------------------------------------------------------
-- Lokale Variablen
-- 'Durchschnitt' und 'Grenze' sind zwei Variablen
-- 'Grenze' hat den fixen Wert 300
-- 'Durchschnitt' von Menge in Tabelle lt
-- Falls die Maximalmenge eines Artikels im Lager 'L1' größer als 'Grenze' ist,
-- soll die Menge vom 'L1'im Lager um den Durchschnitt erhöht werden.

declare @Durchschnitt int, @Grenze int;
Select @Grenze = 300;
Select @Durchschnitt = AVG(menge) 
					   From lt;

if (Select MAX(menge) from lt where lnr = 'L1') > @Grenze
	begin
		Update lt
		Set menge = menge + @Durchschnitt
		Where lnr = 'L1';
	end
go

-------------------------------------------------------
-------------------------------------------------------
-- Stored Procedure 1
-- die Mengen der Tabelle lt sollen um einen mitübergebenen Prozentwert erhöht werden
-- anlegen:

create procedure inc_by_percent 
	@percent decimal(5, 2) --zb 10.12% oder 102.01%
as
	Update lt
	Set menge = menge * (1 + @percent / 100);
go

---------------------------------------------------------
---------------------------------------------------------
-- Stored Procedure 2
-- es soll der übergebene Artikel aus lt gelöscht werden und die mengen der restlichen artikel
-- um 5 % erhöht werden. - verschachtelter prozeduraufruf
-- anlegen:

create procedure del_t 
	@tnr varchar(2)
as
	Delete From lt
	Where lt.tnr = @tnr;
	
	exec inc_by_percent 5;
go

-------------------------------------------------------------
-- Erstellen Sie eine Prozedur del_l (lnr) mit Output-Parameter:
-- Zeile aus L löschen; dabei eventuell vorher entsprechende Zeilen aus lt löschen;
-- zurückgeben, wie viele Zeilen aus lt gelöscht werden mußten

create procedure del_l 
	@lnr varchar(2),
	@del_count int output
as
	Select @del_count = Count(*)
						From lt
						Where lt.lnr = @lnr;
	
	Delete From lt
	Where lt.lnr = @lnr;

	Delete From l
	Where l.lnr = @lnr;
go

-----------------------------------------------------------------
-- Erstellen Sie eine Prozedur clear_lt(m) returning
-- Solange die Summe der Mengen in lt größer als m ist, die Lieferung mit der jeweils niedrigsten Menge
-- löschen; zurückgeben, wie viele Lieferungen gelöscht wurden; keine rekursive Lösung einsetzen
------------------------------------

create procedure clear_lt
	@m int,
	@del_count int output
as
	while (Select SUM(menge) From lt) > @m
		begin
			declare @min_l varchar(2), @min_t varchar(2);

			Select TOP 1 @min_l = lnr, @min_t = tnr 
			From lt
			Order By menge ASC;

			Delete From lt
			Where lt.lnr = @min_l and lt.tnr = @min_t;

			set @del_count = @del_count + 1;
		end
go
