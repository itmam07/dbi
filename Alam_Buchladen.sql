PRAGMA foreign_keys=ON;
.headers on
.mode box
.nullvalue NULL

Drop Table if exists Bestellte_Buecher;
Drop Table if exists Bestellungen;
Drop Table if exists Buecher; 
Drop Table if exists Kunden;

CREATE TABLE Kunden (
    KundenID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100),
    Ort VARCHAR(40)
);

CREATE TABLE Buecher (
    BuchID INT PRIMARY KEY,
    Titel VARCHAR(100),
    Autor VARCHAR(60),
    Preis DECIMAL(10,2),
    Veröffentlichungsjahr INT
);

CREATE TABLE Bestellungen (
    BestellungID INT PRIMARY KEY,
    KundenID INT,
    Bestelldatum DATE,
    FOREIGN KEY (KundenID) REFERENCES Kunden(KundenID)
);

CREATE TABLE Bestellte_Buecher (
    BestellteBuecherID INT PRIMARY KEY,
    BestellungID INT,
    BuchID INT,
    Anzahl INT,
    FOREIGN KEY (BestellungID) REFERENCES Bestellungen(BestellungID),
    FOREIGN KEY (BuchID) REFERENCES Buecher(BuchID)
);

INSERT INTO Kunden (KundenID, Name, Ort, Email) VALUES
(1, 'Anna Schmidt', 'Berlin', 'anna.schmidt@example.com'),
(2, 'Bernd Müller', 'München', 'bernd.mueller@example.com'),
(3, 'Christine Bauer', 'Berlin', 'christine.bauer@example.com'),
(4, 'David Koch', 'Frankfurt', 'david.koch@example.com'),
(5, 'Erika Mustermann', 'Hamburg', 'erika.mustermann@example.com'),
(6, 'Frank Weber', 'Stuttgart', 'frank.weber@example.com'),
(7, 'Greta Lorenz', 'München', 'greta.lorenz@example.com'),
(8, 'Heiko Klein', 'Dortmund', 'heiko.klein@example.com'),
(9, 'Ingrid Fischer', 'Essen', 'ingrid.fischer@example.com'),
(10, 'Jens Vogel', 'Bremen', 'jens.vogel@example.com');

INSERT INTO Buecher (BuchID, Titel, Autor, Preis, Veröffentlichungsjahr) VALUES
(1, 'Die unendliche Geschichte', 'Michael Ende', 18.00, 1979),
(2, 'Momo', 'Michael Ende', 12.00, 1973),
(3, 'Der Prozess', 'Franz Kafka', 15.00, 1925),
(4, 'Das Schloss', 'Franz Kafka', 22.00, 1926),
(5, 'Demian', 'Hermann Hesse', 9.00, 1919),
(6, 'Steppenwolf', 'Hermann Hesse', 7.50, 1927),
(7, 'Der Zauberberg', 'Thomas Mann', 25.00, 1924),
(8, 'Buddenbrooks', 'Thomas Mann', 14.50, 1901),
(9, 'Die Blechtrommel', 'Günter Grass', 19.90, 1959),
(10, 'Im Westen nichts Neues', 'Erich Maria Remarque', 13.00, 1928);

INSERT INTO Bestellungen (BestellungID, KundenID, Bestelldatum) VALUES
(1, 1, '2023-10-01'),
(2, 2, '2023-10-02'),
(3, 3, '2023-10-03'),
(4, 4, '2023-10-04'),
(5, 5, '2023-10-05'),
(6, 6, '2023-10-06'),
(7, 7, '2023-10-07'),
(8, 8, '2023-10-08'),
(9, 9, '2023-10-09'),
(10, 10, '2023-10-10');

INSERT INTO Bestellte_Buecher (BestellungID, BuchID, Anzahl) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 2, 1),
(2, 3, 1),
(3, 4, 1),
(3, 5, 2),
(4, 6, 1),
(4, 7, 1),
(5, 8, 1),
(5, 9, 3),
(6, 10, 2),
(7, 1, 1),
(7, 3, 1),
(8, 2, 2),
(8, 4, 2),
(9, 5, 3),
(9, 7, 1),
(10, 6, 1),
(10, 8, 1);

-- SELECTS
-- a
Select * From Buecher
Where Preis > 20;

-- b
Select K1.Name, K1.Ort From Kunden K1
Join Kunden K2
    ON K1.Ort = K2.Ort AND K1.KundenID != K2.KundenID;

-- c 
Select SUM(BB.Anzahl) AS Anzahl
From Bestellte_Buecher BB
Where BestellungID = 2
Group By BestellungID;

-- d
Select K.Name,
       Bu.Titel,
       B.Bestelldatum
From Kunden K
Join Bestellungen B
    ON K.KundenID = B.KundenID
Join Bestellte_Buecher BB
    ON B.BestellungID = BB.BestellungID
Join Buecher Bu
    ON BB.BuchID = Bu.BuchID
Where Bu.Autor = 'Franz Kafka';

-- e
Select SUM(B.Preis * BB.Anzahl) AS Gesamtwert
From Bestellte_Buecher BB
Join Buecher b
    ON BB.BuchID = B.BuchID;

-- f
Select K.Name, B.Bestelldatum
From Bestellungen B
Join Kunden K
    ON B.KundenID = K.KundenID
Where Bestelldatum > '2023-10-04';

-- g
Select B.BestellungID, B.KundenID, B.Bestelldatum
From Bestellungen B
Join Bestellte_Buecher BB
    ON B.BestellungID = BB.BestellungID
Join Buecher Bu
    ON BB.BuchID = Bu.BuchID
Where Bu.Titel = 'Die unendliche Geschichte';

-- h
Select K.Name, K.Email
From Kunden K
Where K.Email LIKE ('%@gmail.com');

-- i
Select B.BestellungID, B.KundenID, B.Bestelldatum
From Bestellungen B
Join Bestellte_Buecher BB
    ON B.BestellungID = BB.BestellungID
Join Buecher Bu
    ON BB.BuchID = Bu.BuchID
Where Bu.Preis BETWEEN 10 AND 15;

-- j
Select B.BestellungID, K.Name, B.Bestelldatum
From Bestellungen B
Join Kunden K
    ON B.KundenID = K.KundenID
Join Bestellte_Buecher BB
    ON B.BestellungID = BB.BestellungID
Join Buecher Bu
    ON BB.BuchID = Bu.BuchID
Where Bu.Titel = 'Der Prozess' AND K.Ort = 'München';
