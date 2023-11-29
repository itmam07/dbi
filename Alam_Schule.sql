PRAGMA foreign_keys=ON;
.headers on
.mode box
.nullvalue NULL

Drop index if exists idx_Noten_Note;
Drop Table if exists Noten;
Drop index if exists idx_Faecher_Fachbezeichnung;
Drop Table if exists Faecher;
Drop index if exists idx_Schueler_Name;
Drop Table if exists Schueler;
Drop index if exists idx_Klassen_Klassenbezeichnung;
Drop Table if exists Klassen;
Drop index if exists idx_Lehrer_Name;
Drop Table if exists Lehrer;

CREATE TABLE Lehrer (
    LehrerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Fachbereich VARCHAR(100),
    Email VARCHAR(100),
    CHECK(LENGTH(Email) > 10 AND LENGTH(Name) > 5)  -- add CHECK Constraint
);

CREATE index idx_Lehrer_Name On Lehrer (Name);

Insert Into Lehrer (LehrerID, Name, Fachbereich, Email)
Values (1, 'Huber Thomas', 'Mathematik', 'hut@htlwrn.ac.at'),
       (2, 'Brunner Susanne', 'Englisch', 'brs@htlwrn.ac.at'),
       (3, 'Steiger-Lechner Sabine', 'Deutsch', 'sg@htlwrn.ac.at'),
       (4, 'Lackner Sabina', 'Betriebswirtschaft & Management', 'lr@htlwrn.ac.at'),
       (5, 'Reiterer Barbara', 'Fachtheorie Informatik', 'reb@htlwrn.ac.at'),
       (6, 'Eichbarger Jakob', 'Fachtehorie Informatik', 'eij@htlwrn.ac.at'),
       (7, 'Berner Christine', 'Betriebswirtschaft & Management', 'bec@htlwrn.ac.at'),
       (8, 'Weber Margit', 'Fachtheorie Informatik', 'web@htlwrn.ac.at'),
       (9, 'Dorner Elisabeth', 'Mathematik', 'doe@htlwrn.ac.at');

CREATE TABLE Klassen (
    KlasseID INT PRIMARY KEY,
    Klassenbezeichnung VARCHAR(50) UNIQUE,  -- add Unique Constraint
    KlassenlehrerID INT,
    Schuljahr INT NOT NULL,  -- add not null
    Raumnummer VARCHAR(10),
    FOREIGN KEY (KlassenlehrerID) REFERENCES Lehrer(LehrerID),
    CHECK(Raumnummer LIKE 'Z___' AND Klassenbezeichnung LIKE '__HIF')  -- add CHECK Constraint
);

CREATE index idx_Klassen_Klassenbezeichnung ON Klassen (Klassenbezeichnung);

Insert Into Klassen(KlasseID, Klassenbezeichnung, KlassenlehrerID, Schuljahr, Raumnummer)
Values (1, '3CHIF', 8, 2023, 'Z104'),
       (2, '4AHIF', 1, 2023, 'Z310'),
       (3, '1AHIF', 2, 2023, 'Z108'),
       (4, '2BHIF', 8, 2023, 'Z101'),
       (5, '1BHIF', 3, 2023, 'Z307'),
       (6, '2AHIF', 9, 2023, 'Z201');

CREATE TABLE Schueler (
    SchuelerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Geburtsjahr INT NOT NULL,  -- add not null
    KlasseID INT,
    FOREIGN KEY (KlasseID) REFERENCES Klassen(KlasseID),
    CHECK(LENGTH(Name) > 6)  -- add CHECK Constraint
);

CREATE index idx_Schueler_Name ON Schueler (Name);

Insert Into Schueler(SchuelerID, Name, Geburtsjahr, KlasseID)
Values (1, 'Alam Itmam', 2007, 1),
       (2, 'Schmidtberger Ben', 2006, 1),
       (3, 'Supper Elias', 2005, 2),
       (4, 'Eisler Manuel', 2004, 2),
       (5, 'Graf Thomas', 2009, 3),
       (6, 'Hafner Julia', 2009, 3),
       (7, 'Brandtner Fabian', 2009, 5),
       (8, 'Hausberger Niklas', 2009, 5),
       (9, 'Fuchs Tobias', 2008, 4),
       (10, 'Lampl Sebastian', 2008, 4),
       (11, 'Kienast Franziska', 2008, 6),
       (12, 'Mayerhofer Tobias', 2008, 6);

CREATE TABLE Faecher (
    FachID INT PRIMARY KEY,
    Fachbezeichnung VARCHAR(100),
    LehrerID INT,
    FOREIGN KEY (LehrerID) REFERENCES Lehrer(LehrerID)
);

CREATE index idx_Faecher_Fachbezeichnung ON Faecher (Fachbezeichnung);

Insert Into Faecher(FachID, Fachbezeichnung, LehrerID)
Values (1, 'DBI', 8),
       (2, 'DBI', 5),
       (3, 'AM', 1),
       (4, 'AM', 9),
       (5, 'E', 2),
       (6, 'D', 3),
       (7, 'BWM', 4),
       (8, 'BWM', 7),
       (9, 'WMC', 8),
       (10, 'CABS', 8),
       (11, 'SYP', 5),
       (12, 'NSCS', 6);

CREATE TABLE Noten (
    NotenID INT PRIMARY KEY,
    SchuelerID INT,
    FachID INT,
    Note VARCHAR(5),
    Datum DATE,
    FOREIGN KEY (SchuelerID) REFERENCES Schueler(SchuelerID),
    FOREIGN KEY (FachID) REFERENCES Faecher(FachID)
);

CREATE index idx_Noten_Note ON Noten (Note);

Insert Into Noten(NotenID, SchuelerID, FachID, Note, Datum)
Values (1, 1, 1, 2, '2023-06-30'),
       (2, 2, 1, 1, '2023-06-30'),
       (3, 3, 2, 4, '2023-06-30'),
       (4, 4, 5, 5, '2023-06-30'),
       (5, 5, 6, 3, '2023-06-30'),
       (6, 6, 10, 2, '2023-06-30'),
       (7, 7, 12, 2, '2023-06-30'),
       (8, 8, 7, 4, '2023-06-30'),
       (9, 9, 4, 4, '2023-06-30'),
       (10, 10, 11, 1, '2023-06-30'),
       (11, 11, 12, 1, '2023-06-30'),
       (12, 12, 2, 3, '2023-06-30'),
       (13, 12, 1, 3, '2023-06-30'),
       (14, 11, 3, 3, '2023-06-30'),
       (15, 10, 8, 3, '2023-06-30'),
       (16, 9, 9, 4, '2023-06-30'),
       (17, 8, 2, 5, '2023-06-30'),
       (18, 7, 3, 1, '2023-06-30'),
       (19, 6, 1, 1, '2023-06-30'),
       (20, 5, 5, 5, '2023-06-30'),
       (21, 4, 6, 2, '2023-06-30'),
       (22, 3, 7, 3, '2023-06-30'),
       (23, 2, 8, 4, '2023-06-30'),
       (24, 1, 9, 2, '2023-06-30'),
       (25, 1, 10, 3, '2023-06-30'),
       (26, 2, 11, 4, '2023-06-30'),
       (27, 3, 12, 4, '2023-06-30'),
       (28, 4, 6, 3, '2023-06-30'),
       (29, 5, 8, 3, '2023-06-30');


-- SELECTS

-- 1
Select K.Klassenbezeichnung AS Klasse,
       COUNT(S.SchuelerID) AS Schueleranzahl,
       L.Name AS Klassenlehrer
From Klassen K
Join Schueler S
    ON K.KlasseID = S.KlasseID
Join Lehrer L
    ON K.KlassenlehrerID = L.LehrerID
Group By K.Klassenbezeichnung;

-- 2
Select K.Klassenbezeichnung AS Klasse,
       F.Fachbezeichnung AS Fach,
       S.Name,
       N.Note
From Noten N
Join Schueler S
    ON N.SchuelerID = S.SchuelerID
Join Klassen K
    ON S.KlasseID = K.KlasseID
Join Faecher F
    ON N.FachID = F.FachID;

-- 3 FUNKTIONEIRT NUR FÜR ZWEI LEHRER
Select L1.Fachbereich,
       L1.Name,
       L2.Name
From Lehrer L1
Join Lehrer L2
    ON L1.Fachbereich = L2.Fachbereich AND L1.LehrerID < L2.LehrerID;

-- 4
Select S.Geburtsjahr,
       K.Klassenbezeichnung AS Klasse,
       COUNT(S.SchuelerID) AS Schueleranzahl
From Klassen K
Join Schueler S
    ON K.KlasseID = S.KlasseID
Group By S.Geburtsjahr;

-- 5
Select F.Fachbezeichnung,
       COUNT(*) AS '1er 2er 3er'
From Noten N
Join Faecher F
    ON N.FachID = F.FachID
Where N.Note In ('1', '2', '3')
Group By F.Fachbezeichnung;