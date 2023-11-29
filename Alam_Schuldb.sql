PRAGMA foreign_keys=ON;
.headers on
.mode box
.nullvalue NULL

DROP TABLE if exists Unterricht;
DROP TABLE if exists Klasse;
DROP TABLE if exists Lehrkraft;
DROP TABLE if exists Fach;


CREATE Table Fach (
    kuerzel varchar(3) PRIMARY KEY,
    name varchar(50)
);

CREATE Table Lehrkraft (
    persnr int PRIMARY KEY,
    name varchar(25),
    geschl varchar(10),
    wohnort varchar(50),
    geb_jahr int
);

CREATE Table Klasse (
    name varchar(25) PRIMARY KEY,
    zimmer varchar(5),
    persnr int references Lehrkraft
);

CREATE Table Unterricht (
    persnr int references Lehrkraft,
    kuerzel varchar(3) references Fach,
    name varchar(25) references Klasse,
    stundenzahl int,
    PRIMARY KEY(persnr, kuerzel, name)
);

INSERT INTO Fach
VALUES 
('DBI', 'Datenbanken'),
('WMC', 'WMC'),
('POS', 'Programmieren'),
('CABS', 'Computerarchitektur'),
('EN', 'English'),
('D', 'Deutsch'),
('AM', 'Mathematik'),
('GGP','Geschichte und Geografie'),
('BESP','Sport'),
('NW2', 'Naturwissenschaften');

INSERT INTO Lehrkraft
VALUES
(1, 'Margit Weber', 'W', 'Ungarn', 1990),
(2, 'Bernhard Trummer', 'M', 'Wiener Neustadt', 1980),
(3, 'Markus Fischer', 'M', 'Bikini Bottom', 1970),
(4, 'Michael Stifter', 'M', 'Donut Straße', 1933),
(5, 'Thomas Huber', 'M', 'Smoke on The Avenue', 1963),
(6, 'Sabine Steiger-Lechner', 'W', 'Wien', 2000),
(7, 'Jakob Eichberger', 'M', 'Ungarnien', 2010),
(8, 'Elisbeth Dorner', 'W', 'Wiener Neustadt', 1998),
(9, 'Martin Pratscher', 'M', 'Wien', 1999),
(10, 'Sabine Lackner', 'W', 'Spanien', 1990);

INSERt INTO Klasse 
VALUES
('1AHIF', 'Z101', 2),
('1BHIF', 'Z102', 3),
('1CHIF', 'Z103', 4),
('2AHIF', 'Z105', 5),
('2BHIF', 'Z106', 6),
('2CHIF', 'Z107', 7),
('3AHIF', 'Z108', 8),
('3BHIF', 'Z201', 9),
('3CHIF', 'Z104', 1),
('4AHIF', 'Z202', 10);

INSERT INTO Unterricht (persnr, kuerzel, name, stundenzahl)
Values
(1, 'DBI', '3CHIF', 3),
(2, 'POS', '1AHIF', 0),
(3, 'WMC', '1BHIF', 1),
(4, 'CABS', '1CHIF', 5),
(5, 'EN', '2AHIF', 4),
(6, 'AM', '2BHIF', 3),
(7, 'D', '2CHIF', 6),
(8, 'BESP', '3AHIF', 4),
(9, 'NW2', '3BHIF', 3),
(10, 'GGP', '4AHIF', 4);