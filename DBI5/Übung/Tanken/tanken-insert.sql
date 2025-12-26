INSERT INTO Zapfsaeule (ZapfsauleNr, Typ, Hersteller, Selbstbedienung) VALUES (101, 'Standard', 'Gilbarco Veeder-Root', 'Y');
INSERT INTO Zapfsaeule (ZapfsauleNr, Typ, Hersteller, Selbstbedienung) VALUES (102, 'Hochleistung', 'Tokheim', 'Y');
INSERT INTO Zapfsaeule (ZapfsauleNr, Typ, Hersteller, Selbstbedienung) VALUES (103, 'LKW', 'Gilbarco Veeder-Root', 'N');
INSERT INTO Zapfsaeule (ZapfsauleNr, Typ, Hersteller, Selbstbedienung) VALUES (104, 'Standard', 'Wayne Fueling Systems', 'Y');
INSERT INTO Zapfsaeule (ZapfsauleNr, Typ, Hersteller, Selbstbedienung) VALUES (105, 'Standard', 'Tokheim', 'N');

INSERT INTO Kraftstoff (Kraftstoffname, Oktanzahl) VALUES ('Super 95', 95);
INSERT INTO Kraftstoff (Kraftstoffname, Oktanzahl) VALUES ('Diesel', 0);
INSERT INTO Kraftstoff (Kraftstoffname, Oktanzahl) VALUES ('E10', 95);

INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (101, 'Super 95', 2000, 1850);
INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (101, 'Diesel', 2500, 1200);
INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (101, 'E10', 2000, 1200);

INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (102, 'Super 95', 1500, 1450);
INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (102, 'Diesel', 1500, 1200);
INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (102, 'E10', 1500, 1200);

INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (104, 'E10', 3000, 2900);
INSERT INTO Zapfsaule_Kraftstoff (ZapfsauleNr, Kraftstoffname, maxKapazitaet, aktMenge) VALUES (103, 'Diesel', 5000, 4500);

INSERT INTO Tagespreis (Kraftstoffname, Tagesdatum, Preis) VALUES ('Super 95', TO_DATE('15.12.2025', 'DD.MM.YYYY'), 1.659);
INSERT INTO Tagespreis (Kraftstoffname, Tagesdatum, Preis) VALUES ('Super 95', TO_DATE('16.12.2025', 'DD.MM.YYYY'), 1.799);
INSERT INTO Tagespreis (Kraftstoffname, Tagesdatum, Preis) VALUES ('Diesel', TO_DATE('15.12.2025', 'DD.MM.YYYY'), 1.589);
INSERT INTO Tagespreis (Kraftstoffname, Tagesdatum, Preis) VALUES ('E10', TO_DATE('15.12.2025', 'DD.MM.YYYY'), 1.639);
INSERT INTO Tagespreis (Kraftstoffname, Tagesdatum, Preis) VALUES ('E10', TO_DATE('16.12.2025', 'DD.MM.YYYY'), 1.516);
INSERT INTO Tagespreis (Kraftstoffname, Tagesdatum, Preis) VALUES ('E10', TO_DATE('17.12.2025', 'DD.MM.YYYY'), 1.713);
INSERT INTO Tagespreis (Kraftstoffname, Tagesdatum, Preis) VALUES ('Diesel', TO_DATE('14.12.2025', 'DD.MM.YYYY'), 1.499);
