-- 1. Deklaration mit Initialwert
v_num NUMBER := 10;
v_txt VARCHAR2(50) := 'ABC';
v_date DATE := SYSDATE;

-- 2. Separate Zuweisung
v_num := 20;
v_txt := 'DEF';

-- 3. Zuweisung aus SELECT INTO
SELECT sal INTO v_num FROM emp WHERE empno = 7369;

-- 4. Mehrere Variablen aus SELECT INTO
SELECT ename, sal INTO v_txt, v_num FROM emp WHERE empno = 7369;

-- 5. %TYPE
v_sal emp.sal%TYPE := 1000;

-- 6. %ROWTYPE
v_emp emp%ROWTYPE;
SELECT * INTO v_emp FROM emp WHERE empno = 7369;

-- 7. Konstante
c_pi CONSTANT NUMBER := 3.14159;

-- 8. Record (benutzerdefiniert)
TYPE t_rec IS RECORD (
  id   NUMBER,
  name VARCHAR2(50)
);
v_rec t_rec;
v_rec.id := 1;
v_rec.name := 'TEST';

-- 9. Record-Gesamtzuweisung
v_rec := t_rec(2, 'XYZ');

-- 10. PL/SQL-Expression
v_num := v_num * 2 + 5;

-- 11. CASE-Ausdruck
v_num := CASE WHEN v_num > 10 THEN 1 ELSE 0 END;

-- 12. NVL / COALESCE
v_num := NVL(v_num, 0);
v_txt := COALESCE(v_txt, 'N/A');

-- 13. Cursor FETCH
OPEN c1;
FETCH c1 INTO v_num, v_txt;
CLOSE c1;

-- 14. Funktionsrückgabewert
v_num := my_function(p_id => 1);

-- 15. Prozedur mit OUT-Parameter
my_proc(p_out => v_num);

-- 16. BULK COLLECT
SELECT empno BULK COLLECT INTO v_tab FROM emp;

-- 17. FOR-LOOP implizit
FOR r IN (SELECT empno FROM emp) LOOP
  v_num := r.empno;
END LOOP;

-- 18. DEFAULT
v_flag BOOLEAN DEFAULT TRUE;

-- 19. Zuweisung NULL
v_num := NULL;

-- 20. Objekt-Typ
v_obj := my_object_type(1, 'ABC');
