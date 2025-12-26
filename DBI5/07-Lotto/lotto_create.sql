DROP TABLE Annahme CASCADE CONSTRAINTS ;
DROP TABLE Oeffnungszeit CASCADE CONSTRAINTS ;
DROP TABLE Quittung CASCADE CONSTRAINTS ;
DROP TABLE Tipp CASCADE CONSTRAINTS ;
DROP TABLE Ziehung CASCADE CONSTRAINTS ;
DROP TABLE Ziehung_Quittung CASCADE CONSTRAINTS ;
DROP INDEX idx_cLotto;
DROP CLUSTER cLotto;
/


--Sequence f�r Quittungsnummer
drop sequence seq_Quittung;
/
create sequence seq_Quittung
maxvalue 9999999999
increment by 1
start with 1000000000;
/

CREATE CLUSTER cLotto(QuittungsNr number(10));
CREATE INDEX idx_cLotto ON CLUSTER cLotto;


/
CREATE TABLE Annahme
  (
    AnnahmeNr Integer NOT NULL ,
    PLZ       CHAR (5) ,
    Ort       CHAR (30) ,
    Strasse   CHAR (50)
  ) ;
ALTER TABLE Annahme ADD CONSTRAINT Annahme_PK PRIMARY KEY ( AnnahmeNr ) ;

CREATE TABLE Oeffnungszeit
  (
    AnnahmeNr Integer NOT NULL ,
    Wochentag CHAR (2) NOT NULL CHECK (Wochentag IN ('MO', 'DI', 'MI', 'DO', 'FR', 'SA', 'SO')),
    von       CHAR(5)  NOT NULL check (REGEXP_LIKE(von, '(2[0-3])|([01][0-9]):[0-5][05]')),
    bis       CHAR(5) NOT NULL check (REGEXP_LIKE(bis, '(2[0-3])|([01][0-9]):[0-5][05]')),
    CHECK(von < bis)
  ) ;
ALTER TABLE Oeffnungszeit ADD CONSTRAINT Oeffnungszeit_PK PRIMARY KEY ( AnnahmeNr,Wochentag  ) ;

CREATE TABLE Quittung
  (
    QuittungsNr       NUMBER (10) NOT NULL ,
    Zeitpunkt         TIMESTAMP ,
    AnzRunden         NUMBER (2) ,
    AnnahmeNr         INTEGER NOT NULL    
  )
  CLUSTER cLotto(QuittungsNr);
  
ALTER TABLE Quittung ADD CONSTRAINT Quittung_PK PRIMARY KEY ( QuittungsNr ) ;

CREATE TABLE Tipp
  (
    QuittungsNr NUMBER (10) NOT NULL ,
    TippID      INTEGER NOT NULL ,
    ZahlEins   NUMBER (2) check (ZahlEins between 1 and 45),
    ZahlZwei   NUMBER (2) check (ZahlZwei between 1 and 45),
    ZahlDrei   NUMBER (2) check (ZahlDrei between 1 and 45),
    ZahlVier   NUMBER (2) check (ZahlVier between 1 and 45),
    ZahlFuenf  NUMBER (2) check (ZahlFuenf between 1 and 45),
    ZahlSechs  NUMBER (2) check (ZahlSechs between 1 and 45)   
  ) CLUSTER cLotto(QuittungsNr);
  
ALTER TABLE Tipp ADD CONSTRAINT Tipp_PK PRIMARY KEY (QuittungsNr, TippID  ) ;

CREATE TABLE Ziehung
  (
    Datum      DATE NOT NULL ,
    ZahlEins   NUMBER (2) check (ZahlEins between 1 and 45),
    ZahlZwei   NUMBER (2) check (ZahlZwei between 1 and 45),
    ZahlDrei   NUMBER (2) check (ZahlDrei between 1 and 45),
    ZahlVier   NUMBER (2) check (ZahlVier between 1 and 45),
    ZahlFuenf  NUMBER (2) check (ZahlFuenf between 1 and 45),
    ZahlSechs  NUMBER (2) check (ZahlSechs between 1 and 45),
    Zusatzzahl NUMBER (2) check (Zusatzzahl between 1 and 45)
  ) ;
ALTER TABLE Ziehung ADD CONSTRAINT Ziehung_PK PRIMARY KEY ( Datum ) ;

CREATE TABLE Ziehung_Quittung
  (
    Datum       DATE NOT NULL ,
    QuittungsNr NUMBER (10) NOT NULL
  );
  

  
ALTER TABLE Ziehung_Quittung ADD CONSTRAINT Relation_10_PK PRIMARY KEY ( Datum, QuittungsNr ) ;

ALTER TABLE Ziehung_Quittung ADD CONSTRAINT FK_ASS_3 FOREIGN KEY ( Datum ) REFERENCES Ziehung ( Datum ) ;

ALTER TABLE Ziehung_Quittung ADD CONSTRAINT FK_ASS_4 FOREIGN KEY ( QuittungsNr ) REFERENCES Quittung ( QuittungsNr ) ;

ALTER TABLE Oeffnungszeit ADD CONSTRAINT Oeffnungszeit_Annahme_FK FOREIGN KEY ( AnnahmeNr ) REFERENCES Annahme ( AnnahmeNr ) ;

ALTER TABLE Quittung ADD CONSTRAINT Quittung_Annahme_FK FOREIGN KEY (AnnahmeNr ) REFERENCES Annahme ( AnnahmeNr ) ;

ALTER TABLE Tipp ADD CONSTRAINT Tipp_Quittung_FK FOREIGN KEY ( QuittungsNr ) REFERENCES Quittung ( QuittungsNr ) ;

COMMIT;