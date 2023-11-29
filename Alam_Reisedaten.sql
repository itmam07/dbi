PRAGMA foreign_keys=ON;
.headers on
.mode box
.nullvalue NULL

DROP TABLE if exists Hinfluege;
DROP TABLE if exists Rueckfluege;
DROP TABLE if exists Fluege;
DROP TABLE if exists Buchungen;  
DROP TABLE if exists Hotels;
DROP TABLE if exists Reiseziele;
DROP TABLE if exists Kunden;

CREATE TABLE Kunden (
   KNr int PRIMARY KEY,
   Name varchar(20) NOT NULL,
   Vorname varchar(30) NOT NULL,
   Adresse varchar(30) NOT NULL,
   Ort varchar(20) NOT NULL,
   UNIQUE(Name, Adresse, Ort)
);

CREATE TABLE Reiseziele (
    RZNr int PRIMARY KEY,
    Reiseziel varchar(30) UNIQUE NOT NULL
);

CREATE TABLE Hotels (
    HNr int PRIMARY KEY,
    Hotel varchar(20) NOT NULL,
    RZNr varchar(30) references Reiseziele,
    CHECK(Hotel IN ('Hilton', 'Royal', 'Central', 'Aloha', 'Pallas', 'Perle', 'Tropica', 'Mango'))
);

CREATE TABLE Buchungen (
    BNr integer PRIMARY KEY,
    Buchungsdatum Date NOT NULL,
    Preis integer NOT NULL,
    Personen integer NOT NULL,
    CHECK ((Preis >= 50 AND Preis <= 5000) AND ((Personen > 0)))
);

CREATE TABLE Fluege (
    FNr VARCHAR(5) PRIMARY KEY, 
    CHECK(LENGTH(FNr) = 5)
);

CREATE TABLE Rueckfluege (
    BNr integer references Buchungen,
    FNr char(5) references Fluege,
    RFDat date NOT NULL,
    RFZeit time NOT NULL
);

CREATE TABLE Hinfluege (
    BNr integer Buchungen NOT NULL,
    FNr char(5) references Fluege,
    HFDat date NOT NULL,
    HFZeit time NOT NULL
);

INSERT INTO Kunden (KNr, Name, Vorname, Adresse, Ort)
VALUES 
(1, 'Schmidt', 'Anna', 'Hauptstraße 123', 'Berlin'),
(2, 'Müller', 'Peter', 'Am Park 45', 'Hamburg'),
(3, 'Becker', 'Sabine', 'Kirchweg 7', 'München'),
(4, 'Schulz', 'Michael', 'Rosenweg 15', 'Frankfurt'),
(5, 'Wagner', 'Thomas', 'Lindenplatz 2', 'Stuttgart'),
(6, 'Hoffmann', 'Christine', 'Buchenallee 30', 'Dresden'),
(7, 'Koch', 'Andreas', 'Eichenweg 12', 'Leipzig'),
(8, 'Fischer', 'Sandra', 'Tannenstraße 5', 'Düsseldorf'),
(9, 'Weber', 'Daniel', 'Feldweg 8', 'Köln'),
(10, 'Schneider', 'Simone', 'Birkenweg 9', 'Hannover');

INSERT INTO Reiseziele (RZNr, Reiseziel)
VALUES 
(1, 'Paris'),
(2, 'Rom'),
(3, 'Barcelona'),
(4, 'New York'),
(5, 'Tokio'),
(6, 'Sydney'),
(7, 'London'),
(8, 'Prag'),
(9, 'Istanbul'),
(10, 'Dubai');

INSERT INTO Hotels (HNr, Hotel, RZNr)
VALUES
(101, 'Hilton', 1),
(102, 'Royal', 1),
(103, 'Central', 2),
(104, 'Aloha', 2),
(105, 'Pallas', 3),
(106, 'Perle', 3),
(107, 'Tropica', 4),
(108, 'Mango', 4);


INSERT INTO Buchungen (BNr, Buchungsdatum, Preis, Personen)
VALUES 
(1001, '2023-09-28', 350, 2),
(1002, '2023-09-29', 200, 1),
(1003, '2023-10-05', 450, 3),
(1004, '2023-10-10', 600, 2),
(1005, '2023-10-12', 300, 1),
(1006, '2023-10-15', 750, 4),
(1007, '2023-10-20', 400, 2),
(1008, '2023-10-22', 550, 3),
(1009, '2023-10-25', 480, 2),
(1010, '2023-10-28', 900, 5);

INSERT INTO Fluege (FNr)
VALUES 
('FL001'),
('FL002'),
('FL003'),
('FL004'),
('FL005'),
('FL006'),
('FL007'),
('FL008'),
('FL009'),
('FL010');