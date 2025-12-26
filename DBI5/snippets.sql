-- VARIABLENZUWEISUNG
v_num := 10;
v_txt := 'Text';
v_date := SYSDATE;
v_sum := v_a + v_b;
v_flag := CASE WHEN v_sum > 0 THEN 1 ELSE 0 END;
-- SELECT INTO (1 Zeile)
SELECT col1, col2
INTO   v_col1, v_col2
FROM   my_table
WHERE  id = p_id;

-- SELECT INTO mit Aggregat
SELECT COUNT(*)
INTO   v_cnt
FROM   my_table;

-- BULK COLLECT
TYPE t_ids IS TABLE OF NUMBER;
v_ids t_ids;
SELECT id BULK COLLECT INTO v_ids FROM my_table;

-- CONDITIONS
IF v_a = v_b THEN NULL; END IF;
IF v_a > v_b THEN NULL; END IF;
IF v_a BETWEEN 1 AND 10 THEN NULL; END IF;
IF v_txt LIKE '%ABC%' THEN NULL; END IF;
IF v_val IS NULL THEN NULL; END IF;
IF v_val IS NOT NULL THEN NULL; END IF;

-- CASE (Expression)
v_res := CASE v_status
           WHEN 'A' THEN 'AktIV'
           WHEN 'I' THEN 'Inaktiv'
           ELSE 'Unbekannt'
         END;

-- CASE (Condition)
CASE
   WHEN v_salary > 5000 THEN v_grade := 'HIGH';
   WHEN v_salary > 3000 THEN v_grade := 'MID';
   ELSE v_grade := 'LOW';
END CASE;

-- EXISTS Ersatz (empfohlen)
BEGIN
   SELECT 1
   INTO   v_dummy
   FROM   my_table
   WHERE  id = p_id;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      raise_application_error(-20001, 'Datensatz existiert nicht');
END;

-- LOOPS
LOOP
   EXIT WHEN v_i > 10;
   v_i := v_i + 1;
END LOOP;

WHILE v_i <= 10 LOOP
   v_i := v_i + 1;
END LOOP;

FOR i IN 1..10 LOOP
   DBMS_OUTPUT.PUT_LINE(i);
END LOOP;

FOR r IN (SELECT id FROM my_table) LOOP
   DBMS_OUTPUT.PUT_LINE(r.id);
END LOOP;

-- EXCEPTIONS
BEGIN
   SELECT col INTO v_col FROM my_table WHERE id = 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN v_col := NULL;
   WHEN TOO_MANY_ROWS THEN v_col := NULL;
   WHEN OTHERS THEN RAISE;
END;

-- Eigene Exception
e_invalid_value EXCEPTION;
IF v_val < 0 THEN RAISE e_invalid_value; END IF;

-- PROCEDURE / FUNCTION
CREATE OR REPLACE PROCEDURE p_test (
   p_in  IN  NUMBER,
   p_out OUT VARCHAR2
) IS
BEGIN
   p_out := 'OK';
END;
/

CREATE OR REPLACE FUNCTION f_test (
   p_id IN NUMBER
) RETURN VARCHAR2 IS
   v_name VARCHAR2(100);
BEGIN
   SELECT name INTO v_name FROM my_table WHERE id = p_id;
   RETURN v_name;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
END;
/

-- UTILITIES
v_val := NVL(v_val, 0);
v_val := COALESCE(v_val1, v_val2, 0);
