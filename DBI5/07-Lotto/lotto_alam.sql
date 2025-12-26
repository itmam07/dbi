CREATE OR REPLACE FUNCTION Zahlen_udf (
    i_datum IN Ziehung.Datum%TYPE
) RETURN BOOLEAN
AS
    z1 NUMBER;
    z2 NUMBER;
    z3 NUMBER;
    z4 NUMBER;
    z5 NUMBER;
    z6 NUMBER;
    count_distinct NUMBER;
BEGIN
    -- Zahlen aus der Tabelle holen
    SELECT ZahlEins, ZahlZwei, ZahlDrei, ZahlVier, ZAHLFUENF, ZahlSechs
    INTO z1, z2, z3, z4, z5, z6
    FROM Ziehung
    WHERE Datum = i_datum;

    SELECT COUNT(DISTINCT z)
    INTO count_distinct
    FROM (
        SELECT z1 AS z FROM dual UNION ALL
        SELECT z2 FROM dual UNION ALL
        SELECT z3 FROM dual UNION ALL
        SELECT z4 FROM dual UNION ALL
        SELECT z5 FROM dual UNION ALL
        SELECT z6 FROM dual
    );

    -- Prüfen, ob alle verschieden sind
    IF count_distinct = 6
    THEN
        RETURN TRUE;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Keine Ziehung für das angegebene Datum gefunden: ' || TO_CHAR(i_datum, 'YYYY-MM-DD'));
        RETURN FALSE;
END;
/

select Zahlen_udf(to_date('2024-01-06', 'YYYY-MM-DD')) from dual; 

CREATE OR REPLACE PROCEDURE Ziehungen_erzeugen_proc (
    i_startdatum IN DATE,
    i_anzahl IN INTEGER
)
AS
    v_datum DATE := i_startdatum;
    v_remainder NUMBER;
    v_exists NUMBER;
BEGIN
    v_datum := NEXT_DAY(v_datum, 'WEDNESDAY');

    FOR i IN 1 .. i_anzahl LOOP

        SELECT COUNT(*) INTO v_exists
        FROM Ziehung
        WHERE Datum = v_datum;

        IF (v_exists <> 0) THEN
            CONTINUE;
        END IF;

        INSERT INTO Ziehung (Datum)
        VALUES (v_datum);

        v_remainder := MOD(i, 2);

        IF v_remainder = 0 THEN
            v_datum := NEXT_DAY(v_datum, 'WEDNESDAY');
        ELSE
            v_datum := NEXT_DAY(v_datum, 'SUNDAY');
        END IF;
    END LOOP;
END;
/

delete Ziehung;

call Ziehungen_erzeugen_proc (TO_DATE('2024-06-01', 'YYYY-MM-DD'), 5);

Select * from Ziehung;

CREATE OR REPLACE PROCEDURE Wettschein_proc (
    i_AnnahmeNr IN INTEGER,
    i_Zeitpunkt IN TIMESTAMP,
    i_Anzahl_Tips IN INTEGER,
    i_Anzahl_Runden IN INTEGER
)
AS
    v_zahl1 NUMBER(2);
    v_zahl2 NUMBER(2);
    v_zahl3 NUMBER(2);
    v_zahl4 NUMBER(2);
    v_zahl5 NUMBER(2);
    v_zahl6 NUMBER(2);
BEGIN
    IF i_Anzahl_Tips < 1 or i_Anzahl_Tips > 12 THEN
        raise_application_error(-20010, 'Zu viele Tips');
    ELSIF i_Anzahl_Runden < 1 or i_Anzahl_Runden > 12 THEN
        raise_application_error(-20010, 'Zu viele Runden');
    END IF;

    INSERT INTO QUITTUNG (QuittungsNr, Zeitpunkt, AnzRunden, AnnahmeNr) VALUES
    (SEQ_QUITTUNG.nextval, i_Zeitpunkt, i_Anzahl_Runden, i_AnnahmeNr);

    FOR i IN 1 .. i_Anzahl_Tips LOOP
        v_zahl1 := dbms_random.value(1, 45);
        v_zahl2 := dbms_random.value(1, 45);
        v_zahl3 := dbms_random.value(1, 45);
        v_zahl4 := dbms_random.value(1, 45);
        v_zahl5 := dbms_random.value(1, 45);
        v_zahl6 := dbms_random.value(1, 45);

        INSERT INTO TIPP (QuittungsNr, TippID, ZahlEins, ZahlZwei, ZahlDrei, ZahlVier, ZahlFuenf, ZahlSechs)
        VALUES (SEQ_QUITTUNG.currval, i, v_zahl1, v_zahl2, v_zahl3, v_zahl4, v_zahl5, v_zahl6);
    END LOOP;
END;
/

select * from annahme;

call Wettschein_proc(1, systimestamp, 12, 1);

call Wettschein_proc(2, systimestamp, 6, 4);

call Wettschein_proc(3, systimestamp, 3, 8);

select * from quittung;

select * from tipp;


CREATE OR REPLACE PROCEDURE Ziehung_proc (
    i_ziehungstag IN DATE
)
AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM Ziehung
    WHERE Datum = i_ziehungstag;

    IF (v_exists = 0) THEN
        ZIEHUNGEN_ERZEUGEN_PROC(i_ziehungstag, 1);
    END IF;

    UPDATE Ziehung
    SET
        ZahlEins = dbms_random.value(1, 45),
        ZahlZwei = dbms_random.value(1, 45),
        ZahlDrei = dbms_random.value(1, 45),
        ZahlVier = dbms_random.value(1, 45),
        ZahlFuenf = dbms_random.value(1, 45),
        ZahlSechs = dbms_random.value(1, 45),
        Zusatzzahl = dbms_random.value(1, 45)
    WHERE Datum = i_ziehungstag;
END;
/

call Ziehung_proc (TO_DATE('2024-06-05', 'YYYY-MM-DD'));
select * from ziehung where datum = TO_DATE('2024-06-05', 'YYYY-MM-DD');

-- QUERIES

-- 1. Stunden pro Woche je Annahmestelle
Select AnnahmeNr, SUM(TO_NUMBER(TO_DATE(bis, 'HH24:MI') - TO_DATE(von, 'HH24:MI')) * 24) AS Stunden_Pro_Woche
From Oeffnungszeit
Group By AnnahmeNr;

-- 2. Umsatz je Annahmestelle im Jahr ___
Select * FROM(
    Select a.AnnahmeNr,
        a.PLZ,
        a.ORT,
        a.Strasse,
        Count(*) as Umsatz
    From Quittung q
    Join Annahme a on q.ANNAHMENR = a.ANNAHMENR
    Where EXTRACT(YEAR FROM q.Zeitpunkt) = '2025' -- jahr ersetzen
    Group By a.AnnahmeNr, a.PLZ, a.ORT, a.Strasse
    Order By Umsatz DESC
)
Where ROWNUM = 1;

-- 3. Annahmestellen mit den wenigsten Quittungen pro Wochentag
WITH q_count AS (
    -- Quittungen pro Annahme und Wochentag zählen
    SELECT
        a.AnnahmeNr,
        oz.Wochentag,
        COUNT(q.QuittungsNr) AS Anzahl
    FROM Annahme a
    JOIN Oeffnungszeit oz ON oz.AnnahmeNr = a.AnnahmeNr
    LEFT JOIN Quittung q
        ON q.AnnahmeNr = a.AnnahmeNr
       AND TO_CHAR(q.Zeitpunkt, 'DY', 'NLS_DATE_LANGUAGE=GERMAN') = oz.Wochentag
    GROUP BY a.AnnahmeNr, oz.Wochentag
),
min_pro_tag AS (
    SELECT
        Wochentag,
        MIN(Anzahl) AS MinAnzahl
    FROM q_count
    GROUP BY Wochentag
)
SELECT
    qc.Wochentag,
    qc.AnnahmeNr,
    a.PLZ,
    a.Ort,
    a.Strasse,
    qc.Anzahl AS Quittungen
FROM q_count qc
JOIN min_pro_tag mpt
  ON qc.Wochentag = mpt.Wochentag
 AND qc.Anzahl = mpt.MinAnzahl
JOIN Annahme a
  ON a.AnnahmeNr = qc.AnnahmeNr
ORDER BY qc.Wochentag, qc.AnnahmeNr;
