drop table if exists Zapfsaeule cascade constraints;
drop table if exists Kraftstoff cascade constraints;
drop table if exists Zapfsaule_Kraftstoff cascade constraints;
drop table if exists Tagespreis cascade constraints;
drop table if exists Entnahme cascade constraints;

create table Zapfsaeule
(
    ZapfsauleNr number primary key,
    Typ varchar2(50),
    Hersteller varchar2(50),
    Selbstbedienung char(1) check (Selbstbedienung in ('Y', 'N'))
);

create table Kraftstoff
(
    Kraftstoffname varchar2(50) primary key,
    Oktanzahl number
);

create table Zapfsaule_Kraftstoff
(
    ZapfsauleNr number references Zapfsaeule(ZapfsauleNr), 
    Kraftstoffname varchar2(50) references Kraftstoff(Kraftstoffname),
    maxKapazitaet number,
    aktMenge number,
    primary key (ZapfsauleNr, Kraftstoffname)
);

create table Tagespreis
(
    Kraftstoffname varchar2(50) references Kraftstoff(Kraftstoffname),
    Tagesdatum date,
    Preis number,
    primary key (Kraftstoffname, Tagesdatum)
);

create table Entnahme 
(
    EntnahmeNr number primary key,
    Menge number,
    Kraftstoffname varchar2(50) references Kraftstoff(Kraftstoffname),
    ZapfsauleNr number references Zapfsaeule(ZapfsauleNr)
);
