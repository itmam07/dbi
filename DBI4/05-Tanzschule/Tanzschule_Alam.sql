/*
 * author: Itmam Alam
 * database: Tanzschule
**/

drop table if exists termine;
drop table if exists kursbelegung;
drop table if exists tanzkurs;
drop table if exists mitglied;
go

CREATE TABLE Tanzkurs (
    KursNr CHAR(2) NOT NULL,
    Kursname VARCHAR(35),
    Kursleiter CHAR(25),
    Kursstunden INT DEFAULT 10 CHECK (Kursstunden > 9),
    Preis DECIMAL(10,2) DEFAULT 40 CHECK (Preis >= 0)
);

CREATE TABLE Mitglied (
    MitgliedsNr INT NOT NULL IDENTITY,
    Nachname VARCHAR(25),
    Vorname VARCHAR(20),
    Titel VARCHAR(10),
    Gruppe CHAR(1) DEFAULT 'A' NOT NULL,
    TelefonNr VARCHAR(15),
    Plz CHAR(4),
    Ort VARCHAR(20),
    Strasse CHAR(30),
    Gebdat DATETIME CHECK (Gebdat >= '1940-01-01' AND Gebdat <= GETDATE()) NOT NULL,
    Maennlich BIT NOT NULL, -- 1 = männlich, 0 = weiblich
    FamStand VARCHAR(15) CHECK (FamStand IN ('ledig', 'verheiratet', 'verwitwet', 'geschieden')),
    email VARCHAR(40)
);

CREATE TABLE Kursbelegung (
    KursNr CHAR(2) NOT NULL,
    MitgliedsNr INT NOT NULL,
    Tanzleistung INT CHECK (Tanzleistung BETWEEN 1 AND 5)
);

CREATE TABLE Termine (
    KursNr CHAR(2) NOT NULL,
    Termin DATETIME NOT NULL,
    Stunden INT
);

--*****************************************************************************************
set dateformat dmy
INSERT INTO Mitglied (Nachname,Vorname,Titel,Gruppe,TelefonNr,Plz,Ort,Strasse,Gebdat,Maennlich,FamStand,email) VALUES 
	('Kaufmann', 'Patricia',null,'A','01/1234','1070','Wien','Georgirstr.1','01.01.1980',0,'Ledig','pat.kaufman@gmx.at'),
	('Schmidt', 'Barbara','Ing.','A','01/9645123','1011','Wien','Huberstr. 12','12.12.1979',0,'Verheiratet','b.schmidt@gmx.at'),
	('Braun', 'Oliver','DI.FH','C','01/345123','1010','Wien','Wienerstr.123','23.07.1978',1,'Geschieden','oliver@gmx.at'),
	('Kiefer', 'Bernd',null,'D','02622/123455','2700','Wr.Neustadt','Deichgasse 12','11.11.1944',1,'Ledig',Null),
	('Schmolke', 'Tom',null,'B','02622/6543','2700','Wr.Neustadt','Karlgasse 23','21.04.1956',1,'Verwitwet','tom.schmolke@gmail.com'),
	('Hansen',	'Gertrud',null,'A','02622/72974','2700','Wr.Neustadt','Landlgasse 23','14.06.1965',0,'Ledig','hansen@gmail.com'),
	('Blume', 'Simon','Dr.','B','0732/45646','4020','Linz','Wiensrstr. 120','23.01.1967',1,'Verheiratet','blume12@gmail.com'),
	('Kraus', 'Margit',null,'C','0732/56234','4020','Linz','Friedrichgasse 5','02.03.1959',0,'Verheiratet','margit.kraus@gmail.com'),
	('Hugo', 'Xaver','Mag.','A','01/34567','1010','Wien','Paulistr.34','23.01.1970',1,'Geschieden','xaver@gmail.com'),
	('Tobisch', 'Lotte',null,'B','02622/5677','1020','Wr.Neustadt','Wienerstr.123','01.05.1978',0,'Ledig','tobisch@gmail.com'),
	('Müller','Otto','Dipl.Ing.','C','01/3451','1010','Wien','Linzerstr. 44','03.04.1982',0,'Ledig','mueller@gmail.com'),
	('Müller','Anna',null,'A','02732/123','4020','Linz','Leondingerstr.33','26.09.1978',0,'Ledig','mueller@gmail.com'),
	('Schmied','Paul',null,'A','02732/4565','4020','Linz','Hafenstr.89','12.03.1988',0,'Ledig','paul.schmied@gmail.com'),
	('Lotto','Inge','Dipl.Ing.','A','0456/89','8010','Graz','Wienerstr.567','01.01.1980',0,'Ledig','inge.lotto@gmail.com'),
	('Huber','Georg','Ing.','B',NULL,'8010','Graz','Wienerstr:23','12.07.1978',0,'Ledig','huber@gmail.com'),
	('Feiner','Hannes','Dr.','A',NULL,'2352','Mödling','Hinterbröhlerstr.12','23.07.1967',0,'Verheiratet','feiner@gmx.at'),
	('Degen','Walter',null,'A',NULL,'2352','Mödling','Perchtoldsdorferstr. 3','19.07.1970',0,'Verwitwet',Null);
-- select * from mitglied;
go


INSERT INTO Tanzkurs (KursNr,Kursname,Kursleiter,Kursstunden,Preis) VALUES 
	('D2','Tango','Meier',14,90),
	('A3','Lateinamerikanische Tänze','Meier',10,40),
	('C3','Salsa','Meier',10,60),
	('E1','Wiener Walzer','Grimm',10,40),
	('E2','Englischer Walzer','Sommer',10,40),
	('A1','Standard 1','Müller',20,60),
	('A2','Standard 2','Müller',20,60),
	('B1','Step','Grimm',10,90),
	('C1','Moderne T�nze','Sommer',15,90),
	('C2','Rock'+''''+'n Roll','Sauer',15,80),
	('D1','Bewegungstherapie','Grimm',20,100);
-- select * from tanzkurs;
go

INSERT INTO Termine (KursNr,Termin,Stunden) VALUES 
	('D2','2.3.2021',2),
	('D2','9.3.2021',2),
	('D2','16.3.2021',2),
	('D2','23.3.2021',2),
	('D2','2.4.2021',2),
	('D2','6.4.2021',2),
	('D2','13.4.2021',2),
	('A3','4.3.2021',5),
	('A3','5.3.2021',5),
	('C3','27.2.2021',4),
	('C3','28.2.2021',4),
	('C3','1.3.2021',2),
	('E1','5.6.2021',5),
	('E1','12.6.2021',5),
	('E2','5.6.2021',5),
	('E2','12.6.2021',5),
	('A1','5.6.2021',4),
	('A1','12.6.2021',4),
	('A1','19.6.2021',4),
	('A1','26.6.2021',4),
	('A1','1.7.2021',4),
	('A2','8.7.2021',4),
	('A2','12.7.2021',4),
	('A2','16.7.2021',4),
	('A2','20.7.2021',4),
	('A2','24.7.2021',4),
	('B1','2.5.2021',5),
	('B1','3.5.2021',5),
	('C1','2.5.2021',5),
	('C1','3.5.2021',5),
	('C1','4.5.2021',5),
	('C2','2.5.2021',5),
	('C2','3.5.2021',5),
	('C2','4.5.2021',5),
	('D1','2.6.2021',5),
	('D1','3.6.2021',5),
	('D1','4.6.2021',5),
	('D1','2.5.2021',5),
	('C1','4.5.2021',5),
	('C2','2.5.2021',5),
	('C2','3.5.2021',5),
	('C2',getdate() + 12,5),
	('D1',getdate() + 31,5),
	('D1',getdate() + 15,5),
	('D1',getdate() + 16,5),
	('D1',getdate() + 33,5);
-- select * from Termine
go

INSERT INTO Kursbelegung (KursNr,MitgliedsNr,Tanzleistung) VALUES 
	('A1',3,2),
	('A1',4,2),
	('A1',5,2),
	('A1',8,2),
	('A2',1,1),
	('A2',3,2),
	('A2',7,3),
	('B1',2,5),
	('B1',3,2),
	('B1',6,NULL),
	('C1',4,2),
	('C1',5,2),
	('C2',1,1),
	('C2',2,2),
	('C2',3,2),
	('C2',4,2),
	('C2',5,2),
	('D1',7,5),
	('D1',8,1);
-- select * from kursbelegung;
go

-- SQL Queries
-- a. Zeige eine aktuelle Namensliste aller Mitglieder und ihre Telefonnummern
SELECT Nachname, Vorname, TelefonNr
FROM Mitglied;

-- b. Welche Kurse (Kursname, danach aufsteigend sortiert) bieten wir an?
SELECT Kursname
FROM Tanzkurs
ORDER BY Kursname ASC;

-- c. Welchen Gruppen sind die Mitglieder zugeordnet? (sortiert nach Gruppe und Nachname)
SELECT Gruppe, Nachname, Vorname
FROM Mitglied
ORDER BY Gruppe ASC, Nachname ASC;

-- d. Zeige alle Mitgliederinformationen an
SELECT *
FROM Mitglied;

-- e. In welchen Orten wohnen die Mitglieder? (Ort, danach sortiert)
SELECT DISTINCT Ort
FROM Mitglied
ORDER BY Ort ASC;

-- f. Gib alle angebotenen Tanzkurse in absteigender, alphabetischer Reihenfolge aus
SELECT Kursname
FROM Tanzkurs
ORDER BY Kursname DESC;

-- g. Gib eine Liste aller Mitgliedernamen in der absteigenden Reihenfolge der Postleitzahlen aus
SELECT Nachname, Vorname
FROM Mitglied
ORDER BY Plz DESC;

-- h. Zeige die Namen aller Mitglieder mit ihrer Telefonnummer und Mitgliedsnummer und sortiere sie nach Nachname und Vorname
SELECT MitgliedsNr, Nachname, Vorname, TelefonNr
FROM Mitglied
ORDER BY Nachname ASC, Vorname ASC;

-- i. Zeige die Namen aller Mitglieder mit ihrer Telefonnummer und Mitgliedsnummer und sortiere sie nach Nachname absteigend und Vorname aufsteigend
SELECT MitgliedsNr, Nachname, Vorname, TelefonNr
FROM Mitglied
ORDER BY Nachname DESC, Vorname ASC;

-- j. Geben Sie die Emailadressen aller Mitglieder wie folgt aus;
-- mustermann@gmx.at ist die Emailadresse von Max Mustermann
SELECT CONCAT(email, ' ist die Emailadresse von ', Vorname, ' ', Nachname) AS Email
FROM Mitglied;

-- k. Wie alt sind unsere Mitglieder? (Alter in Jahren, Angabe als Gleitkommazahl)
SELECT Nachname, Vorname, 
       DATEDIFF(DAY, Gebdat, GETDATE()) / 365.25 AS AlterX
FROM Mitglied;

-- l. Wie heißen die Mitglieder, die nicht in Wien wohnen?
SELECT Nachname, Vorname
FROM Mitglied
WHERE Ort <> 'Wien';

-- m. Zeige die Vor- und Nachnamen aller Mitglieder, die am 1. Jänner 1980 geboren wurden
SELECT Vorname, Nachname
FROM Mitglied
WHERE Gebdat = '1980-01-01';

-- n. Zeige die Liste aller Tanzkurse mit mehr als 12 Tanzstunden.
SELECT Kursname
FROM Tanzkurs
WHERE Kursstunden > 12;

-- o. Welche Mitglieder wurden im Juli 1970 geboren?
SELECT Nachname, Vorname
FROM Mitglied
WHERE MONTH(Gebdat) = 7 AND YEAR(Gebdat) = 1970;

-- p. Welche Mitglieder wohnen in Wiener Neustadt, Neunkirchen, Baden, Eisenstadt?
SELECT Nachname, Vorname
FROM Mitglied
WHERE Ort IN ('Wr.Neustadt', 'Neunkirchen', 'Baden', 'Eisenstadt');

-- q. Zeige eine Liste aller Mitglieder, die ihre Postleitzahl nicht angegeben haben.
SELECT Nachname, Vorname
FROM Mitglied
WHERE Plz IS NULL OR Plz = '';

-- r. Zeige alle Mitglieder, die weder den Titel „Ing.“, „Dipl.Ing.“ oder „Dr.“ haben
SELECT Nachname, Vorname
FROM Mitglied
WHERE Titel NOT IN ('Ing.', 'Dipl.Ing.', 'Dr.');

-- s. Zeige alle Mitglieder, in deren Familiennamen ein „e“ vorkommt und deren Nachname genau 5 Zeichen lang ist.
SELECT Nachname, Vorname
FROM Mitglied
WHERE Nachname LIKE '%e%' AND LEN(Nachname) = 5;

-- t. Liste aller Kurse mit Terminen (Kursname, Kursleiter, Termin), die in der Zukunft stattfinden,
-- absteigend sortiert nach Kursleiter und Termin
SELECT t.Kursname, t.Kursleiter, tm.Termin
FROM Tanzkurs t
JOIN Termine tm ON t.KursNr = tm.KursNr
WHERE tm.Termin > GETDATE()
ORDER BY t.Kursleiter DESC, tm.Termin DESC;

-- u. Liste aller männlichen Mitglieder (Nach- und Vorname, Alter in Jahren), die einen Kurs belegt haben, sortiert nach Alter
SELECT m.Nachname, m.Vorname, 
       DATEDIFF(DAY, m.Gebdat, GETDATE()) / 365.25 AS AlterInJahren
FROM Mitglied m
JOIN Kursbelegung kb ON m.MitgliedsNr = kb.MitgliedsNr
WHERE m.Maennlich = 1
ORDER BY AlterInJahren ASC;

-- v. Liste jener Mitglieder (Nachname), die den gleichen Nachnamen wie ein Kursleiter haben
SELECT DISTINCT m.Nachname
FROM Mitglied m
JOIN Tanzkurs t ON m.Nachname = t.Kursleiter;

-- w. Liste aller Tanzkurse (KursNr, Tanzleistung) mit den Mitgliedernamen (Nach- und Vorname),
-- die den Tanzkurs belegt haben, innerhalb des Kurses sollen die Mitglieder nach Nachname sortiert sein
SELECT t.KursNr, kb.Tanzleistung, m.Nachname, m.Vorname
FROM Kursbelegung kb
JOIN Mitglied m ON kb.MitgliedsNr = m.MitgliedsNr
JOIN Tanzkurs t ON kb.KursNr = t.KursNr
ORDER BY t.KursNr, m.Nachname ASC;
