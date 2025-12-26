use lt;

--Benutzerdefinierten Datentyp "Prozent" anlegen
CREATE TYPE Prozent FROM int NOT NULL;
GO

drop table if exists lt;
drop table if exists l;
drop table if exists t;

create table l (
  lnr    varchar(2) not null primary key
, lname  varchar(6) not null unique
, rabatt Prozent not null DEFAULT 0 CHECK(rabatt BETWEEN 0 AND 100)
, stadt  varchar(6) not null
);

create table t (
  tnr    varchar(2)    not null primary key
, tname  varchar(8)    not null
, farbe  varchar(5)    not null
, preis  decimal(4, 2) not null
, stadt  varchar(6)    not null
, check(stadt <> farbe)
);

create table lt (
  lnr    varchar(2) not null references l
, tnr    varchar(2) not null references t
, menge  decimal(4) not null check(menge > 0)
, primary key (lnr, tnr)
);

insert into l
  (lnr,  lname   , rabatt, stadt   )
values
  ('L1', 'Schmid',     20, 'London')
, ('L2',  'Jonas',     10, 'Paris' )
, ('L3', 'Berger',     30, 'Paris' )
, ('L4',  'Klein',     20, 'London')
, ('L5',   'Adam',     30, 'Athen' )
;

insert into t
  (tnr , tname     , farbe  , preis, stadt   )
values
  ('T1', 'Mutter'  , 'rot'  ,    12, 'London')
, ('T2', 'Bolzen'  , 'gelb' ,    17, 'Paris' )
, ('T3', 'Schraube', 'blau' ,    17, 'Rom'   )
, ('T4', 'Schraube', 'rot'  ,    14, 'London')
, ('T5', 'Welle'   , 'blau' ,    12, 'Paris' )
, ('T6', 'Zahnrad' , 'rot'  ,    19, 'London')
;

insert into lt
  (lnr , tnr,  menge)
values
  ('L1', 'T1',   300)
, ('L1', 'T2',   200)
, ('L1', 'T3',   400)
, ('L1', 'T4',   200)
, ('L1', 'T5',   100)
, ('L1', 'T6',   100)
, ('L2', 'T1',   300)
, ('L2', 'T2',   400)
, ('L3', 'T2',   200)
, ('L4', 'T2',   200)
, ('L4', 'T4',   300)
, ('L4', 'T5',   400)
;

--View LTX erstellen
DROP VIEW IF EXISTS LTX;
CREATE OR ALTER VIEW LTX AS
	SELECT T.tnr, T.tname, L.lnr, L.lname, LT.menge
	FROM LT
	JOIN T ON LT.tnr = T.tnr
	JOIN L ON LT.lnr = L.lnr;
Go

--a) Welche Spalten enth�lt die Tabelle L?
select column_name
from information_schema.columns
where table_name = 'l';

--b) Welche Tabellen / Views / Tabellen oder Views enthalten eine Spalte STADT?
select table_name
from information_schema.columns
where column_name = 'stadt';

--c) Wieviele Spalten enth�lt die Tabelle LT?
select count(*) as anzahl_spalten
from information_schema.columns
where table_name = 'lt';

--d) Wieviele Spalten haben die einzelnen Tabellen / Views?
select table_name, count(*) as anzahl_spalten
from information_schema.columns
group by table_name;

--e) Wieviele Fremdschl�ssel sind in der Tabelle LT enthalten?
select count(*) as anzahl_fremdschluessel
from information_schema.table_constraints tc
where tc.table_name = 'lt'
  and tc.constraint_type = 'FOREIGN KEY';

--f) Welche Tabellen haben einen zusammengesetzten Prim�rschl�ssel?
select tc.table_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu
  on tc.constraint_name = kcu.constraint_name
where tc.constraint_type = 'PRIMARY KEY'
group by tc.table_name
having count(kcu.column_name) > 1;

--g) Welche Tabellen haben einen zusammengesetzten Fremdschl�ssel?
select tc.table_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu
  on tc.constraint_name = kcu.constraint_name
where tc.constraint_type = 'FOREIGN KEY'
group by tc.table_name
having count(kcu.column_name) > 1;

--h) Welche Tabellen enthalten keinen Unique-Constraint?
select t.table_name
from information_schema.tables t
where t.table_type = 'BASE TABLE'
  and not exists (
    select 1
    from information_schema.table_constraints tc
    where tc.table_name = t.table_name
      and tc.constraint_type = 'UNIQUE'
  );

--i) Welche Tabellen kommen in der View LTX vor?
select distinct table_name
from information_schema.view_table_usage
where view_name = 'LTX';

--j) In welchen Views kommt die Tabelle L vor?
select view_name
from information_schema.view_table_usage
where table_name = 'l';

--k) In welchen Views kommen die Tabellen L und T vor?
select vtu1.view_name
from information_schema.view_table_usage vtu1
join information_schema.view_table_usage vtu2
  on vtu1.view_name = vtu2.view_name
where vtu1.table_name = 'l'
  and vtu2.table_name = 't';

--l) In welchen / wievielen Tabellen kommt eine Spalte mit dem Datentyp DECIMAL vor?
select table_name, count(*) as anzahl_spalten
from information_schema.columns
where data_type = 'decimal'
group by table_name;

--m) Welche Spalten (Tabellen- und Spaltenname) d�rfen nicht NULL sein?
select table_name, column_name
from information_schema.columns
where is_nullable = 'NO';

--n) In welchen Check-Constraints kommt die Spalte STADT vor?
select constraint_name
from information_schema.check_constraints cc
join information_schema.constraint_column_usage ccu
  on cc.constraint_name = ccu.constraint_name
where ccu.column_name = 'stadt';

--o) Welche Tabellen werden von einem Fremdschl�ssel referenziert?
select distinct kcu.table_name
from information_schema.referential_constraints rc
join information_schema.key_column_usage kcu
  on rc.unique_constraint_name = kcu.constraint_name;