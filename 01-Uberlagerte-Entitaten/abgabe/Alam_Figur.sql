use Figur;

Drop Table if exists Quadrat;
Drop Table if exists Kreis;
Drop Table if exists Figur;

/*

1 B: Sehr redundant, da alle Attribute des Super Entity typen itgespeichert werden

Create Table Figur (
    FigurID int primary key,
    Fläche int,
    Farbe varchar(10)
);

Create Table Kreis (
    FigurID int primary key references Figur,
    Fläche int,
    Farbe varchar(10),
    Umfang int, 
    Radius int
);

Create Table Quadrat (
    FigurID int primary key references Figur,
    Fläche int,
    Farbe varchar(10),
    Seite int, 
    Diagonale int
);

Insert Into Figur(FigurID, Fläche, Farbe)
Values (1, 314, 'grün'),
       (2, 3, 'blau'),
       (3, 10, 'rot'),
       (4, 4, 'grün'),
       (5, 24, 'blau'),
       (6, 10, 'rot');

Insert Into Kreis(FigurID, Fläche, Farbe, Umfang, Radius)
Values (1, 314, 'grün', 63, 10),
       (2, 3, 'blau', 6, 1),    
       (3, 10, 'rot', 10, 2);   

Insert Into Quadrat(FigurID, Fläche, Farbe, Seite, Diagonale)
Values (4, 4, 'grün', 2, 3), 
       (5, 24, 'blau', 4, 6),
       (6, 10, 'rot', 3, 4);

-- 1 B

-- alle infos zu einem subtyp
Select Umfand, Radius From Kreis;
Select Seite, Diagonale From Quadrat;

-- alle infos zu allen entities
Select f.*, s.*
From Figur f
Join Kreis k on f.FigurID = k.FigurID;
Union All
Select f.*, q.*
From Figur f
Join Quadrat q on f.FigurID = q.FigurID;
*/

-- 1 A
Create Table Figur (
    FigurID int primary key,
    Fläche float,
    Farbe varchar(10)
);

Create Table Kreis (
    FigurID int primary key references Figur,
    Umfang float, 
    Radius float,
);

Create Table Quadrat (
    FigurID int primary key references Figur,
    Seite float, 
    Diagonale float
);

Insert Into Figur(FigurID, Fläche, Farbe)
Values (1, 314.16, 'grün'),
       (2, 3.14, 'blau'),
       (3, 10, 'rot'),
       (4, 4, 'grün'),
       (5, 24, 'blau'),
       (6, 10, 'rot');

-- Umfang = 2 * pi * Radius
Insert Into Kreis(FigurID, Umfang, Radius)
Values (1, 62.83, 10),
       (2, 6.28, 1),
       (3, 10, 1.59);

-- Diagonale = Seite * sqrt(2)
Insert Into Quadrat(FigurID, Seite, Diagonale)
Values (4, 42, 59.40),
       (5, 24, 33.94),
       (6, 10, 14.14);


-- 1 A

-- alle infos zu einem subtyp
Select * From Kreis;
Select * From Quadrat;

-- alle infos zu allen entities
Select f.*, s.*
From Figur f
Join Kreis k on f.FigurID = k.FigurID;
Union All
Select f.*, q.*
From Figur f
Join Quadrat q on f.FigurID = q.FigurID;

 