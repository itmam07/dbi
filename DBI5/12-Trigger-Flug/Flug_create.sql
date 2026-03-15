drop table geschult;
drop table Pilot;
drop table Flugzeug;
drop table Flug;
drop table Typ;
/   

CREATE TABLE Typ 
    ( 
     TNr NUMBER(2)  NOT NULL  PRIMARY KEY , 
     TBezeichnung VARCHAR2 (35) , 
     Sitzplaetze NUMBER (4) 
    )  
;
 
CREATE TABLE Flugzeug 
    ( 
     FZNr NUMBER (5)  NOT NULL PRIMARY KEY  , 
     Kennzeichen VARCHAR2 (35) , 
     Kaufdatum DATE  NOT NULL , 
     Flugstunden interval day to second default (interval '0'  second),  
     TNr NUMBER  REFERENCES Typ 
    )  
;

CREATE TABLE Pilot 
    ( 
     PNr NUMBER(2)  NOT NULL PRIMARY KEY, 
     PName VARCHAR2 (35) , 
     PVorname VARCHAR2 (35) , 
     GebDat DATE , 
     ModDat DATE , 
     ModUser VARCHAR2 (35) 
    ) 
;
CREATE TABLE Flug 
    ( 
     FNr NUMBER (4)  NOT NULL   , 
     Abflug Timestamp  , 
     Ankunft Timestamp , 
     von VARCHAR2 (30) , 
     nach VARCHAR2 (30) , 
     PNr NUMBER(2)  NOT NULL , 
     FZNr NUMBER (5)  NOT NULL,
     PRIMARY KEY(FNR,Abflug)
    ) 
;

CREATE TABLE geschult 
    ( 
     Pilot_PNr NUMBER(2)  NOT NULL References Pilot(Pnr), 
     Typ_TNr NUMBER(2)  NOT NULL REFERENCES Typ(TNr),
     PRIMARY KEY ( Pilot_PNr, Typ_TNr )
    )
;




    
    
    
 