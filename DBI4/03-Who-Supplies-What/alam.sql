/*
 * 
 * itmam alam
 * 04.10.2024
 * alam_db.sql
 *
**/


-- ################
-- ##  DATABASE  ##
-- ################

Create Database Catalog
on
(
	name = 'catalog_data',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\catalog_data.mdf',
	size = 10MB,
	filegrowth = 10%
)
log on
(
	name = 'catalog_log',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\catalog_log.ldf',
	size = 2MB,
	filegrowth = 10%
);


-- ##############
-- ##  TABLES  ##
-- ##############

use WhoSuppliesWhat;

Drop Table if exists SupplierParts;
Drop Table if exists Parts;
Drop Table if exists Suppliers;

Create Table Suppliers
(
	SupplierID varchar(2) primary key,
	SupplierName varchar(6),
	SupplierCity varchar(6),
	SupplierDiscount int
);

Create Table Parts
(
	PartID varchar(2) primary key,
	PartName varchar(8),
	PartColor varchar(6),
	PartPrice decimal(6, 2),
	PartCity varchar(6)
);

Create Table SupplierParts
(
	SupplierID varchar(2) references Suppliers,
	PartID varchar(2) references Parts,
	Amount int,
	primary key (SupplierID, PartID)
);


-- ###############
-- ##  INSERTS  ##
-- ###############

Insert Into Suppliers (SupplierID, SupplierName, SupplierCity, SupplierDiscount)
Values
('L1', 'Schmid', 'London', 20),
('L2', 'Jonas' , 'Paris' , 10),
('L3', 'Berger', 'Paris' , 30),
('L4', 'Klein' , 'London', 20),
('L5', 'Adam' , 'Athen' , 30);

Insert Into Parts (PartID, PartName, PartColor, PartPrice, PartCity)
Values
('T1', 'Mutter' , 'rot' , 12, 'London'),
('T2', 'Bolzen' , 'gelb', 17, 'Paris' ),
('T3', 'Schraube', 'blau', 17, 'Rom' ),
('T4', 'Schraube', 'rot' , 14, 'London'),
('T5', 'Welle' , 'blau', 12, 'Paris' ),
('T6', 'Zahnrad' , 'rot' , 19, 'London');

Insert Into SupplierParts (SupplierID, PartID, Amount)
Values
('L1', 'T1', 300),
('L1', 'T2', 200),
('L1', 'T3', 400),
('L1', 'T4', 200),
('L1', 'T5', 100),
('L1', 'T6', 100),
('L2', 'T1', 300),
('L2', 'T2', 400),
('L3', 'T2', 200),
('L4', 'T2', 200),
('L4', 'T4', 300),
('L4', 'T5', 400);


-- ###############
-- ##  QUERIES  ##
-- ###############

-- a.
Select PartName, PartPrice
From Parts
Where PartPrice < (Select AVG(PartPrice) From Parts);

-- b.
Select s.SupplierID, 
       SUM(sp.Amount * p.PartPrice * (1 - s.SupplierDiscount / 100.0)) as Total -- important 100.0 not 100
From Suppliers s
Join SupplierParts sp on s.SupplierID = sp.SupplierID
Join Parts p on sp.PartID = p.PartID
Group By s.SupplierID;

-- c.
Select Distinct PartName 
From Parts p
Join SupplierParts sp on p.PartID = sp.PartID
Where p.PartCity = (Select SupplierCity
					From Suppliers 
					Where SupplierID = 'L3');


-- #############
-- ##  ALTER  ##
-- #############


-- rename DB
Alter Database Catalog 
modify name = WhoSuppliesWhat;

-- add data file
Alter Database WhoSuppliesWhat
add File (
	name = 'who_supplies_what_data',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\who_supplies_what_data.mdf',
	size = 10MB,
	filegrowth = 10%
);


-- #################
-- ##  Questions  ##
-- #################

/*
 * GO
 *
 * Wird verwendet um mehrere SQL Anweisungen voneinander zu trennen. 
 * Es gehört nicht zur SQL Syntax selbst, sondern dient als Befehl
 * an den SQL Server die vorangegangen Befehle als Batch (einen Stapel)
 * gesammelt auszuführen. Man kann GO verwenden um zb verschiedene Teile
 * eines SQL Skripts semantisch zu teilen. (Create Tables, Inserts, Queries, etc.)
 * 
 *
 * Ort der Datenfiles einer SQL Server DB?
 * 
 * 1. Abfrage auf sys.master_files
 *
 *  Select 
 *    name as FileName, 
 *    physical_name as FilePath,
 *    type_desc as FileType
 *  From 
 *    sys.master_files
 *    where database_id = DB_ID('WhoSuppliesWhat');
 *
 * 2. SSMS
 *
 * Rechtsklick auf DB -> Properties -> Files
**/


-- ##############
-- ##  Delete  ##
-- ##############

Drop Database if exists WhoSuppliesWhat;

-- Wenns nd geht dann muss es im single user mod ausgführt 
-- werden um sicherzustellen dass niemand verbunden ist