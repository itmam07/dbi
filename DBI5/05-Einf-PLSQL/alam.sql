-- Übung 2
-- 1. Erstellen Sie die Tabelle areas mit geeigneten Datentypen.
-- 2. Testen Sie den anonymen Block zur Kreisflächenberechnung.
-- 3. Fragen Sie die Tabelle areas ab, um zu testen, ob der Block wie erwartet funktioniert hat.

create table areas (
   radius number,
   area   number
);

clear screen;
declare
   pi     constant number(
      9,
      7
   ) := 3.1415927;
   radius integer;
   area   number(
      14,
      2
   );
begin
   radius := 3;
   area := pi * power(
      radius,
      2
   );
   insert into areas values ( radius,
                              area );
   commit;
end;
/
show errors

select *
  from areas;

-- Übung 3
-- 1. Erstellen Sie die Tabelle radius_values mit geeigneten Datentypen.
-- 2. Fügen Sie einen Datensatz mit beliebigem Radius ein.
-- 3. Testen Sie den anonymen Block zur Kreisflächenberechnung mit Cursor.
-- 4. Fragen Sie die Tabelle areas ab, um zu testen, ob der Block wie erwartet funktioniert hat.
-- 5. Erklären Sie die Funktion von %rowtype.
-- 6. Ersetzen Sie den PL/SQL-Block durch ein INSERT kombiniert mit SELECT, das die gleiche Änderung bewirkt. Testen
-- Sie das Kommando.
-- 7. Ersetzen Sie den PL/SQL-Block und das Anlegen der Tabelle areas, indem Sie das Kommando create table areas_ as
-- select... verwenden. Sehen Sie sich mit desc areas_ die Struktur der erzeugten Tabelle an.

create table radius_values (
   radius number
);
insert into radius_values values ( 5 );

clear screen
declare
   pi         constant number(
      9,
      7
   ) := 3.1415927;
   area       number(
      14,
      2
   );
   cursor radius_cursor is
   select *
     from radius_values;
   radius_row radius_cursor%rowtype;
begin
   open radius_cursor;
   fetch radius_cursor into radius_row;
   area := pi * power(
      radius_row.radius,
      2
   );
   insert into areas values ( radius_row.radius,
                              area );

   close radius_cursor;
   commit;
end;
/
show errors

select *
  from areas;

-- 6
insert into areas (
   radius,
   area
)
   select radius,
          3.1415927 * power(
             radius,
             2
          )
     from radius_values;

-- 7
create table areas_
   as
      select radius,
             3.1415927 * power(
                radius,
                2
             ) as area
        from radius_values;

desc areas_;

-- Übung 4
-- 1. Erweitern Sie das Kreisberechnungsbeispiel (mit Cursor), indem Sie nur dann den Datensatz einfügen, wenn die Fläche
-- größer als 30 ist.
-- 2. Schreiben Sie zwei Testfälle, bei denen das einmal der Fall ist und einmal nicht.
-- 3. Fragen Sie die Tabelle areas jeweils ab, um zu prüfen, ob der Block wie erwartet funktioniert hat.
delete from areas;
delete from radius_values;
insert into radius_values values ( 5 );

clear screen
declare
   pi constant number(
      9,
      7
   ) := 3.1415927;
   area       number(
      14,
      2
   );
   cursor radius_cursor is
   select *
     from radius_values;
   radius_row radius_cursor%rowtype;
begin
   open radius_cursor;
   fetch radius_cursor into radius_row;
   area := pi * power(
      radius_row.radius,
      2
   );
   dbms_output.put_line('area: ' || area);
   if area > 30 then
      insert into areas values ( radius_row.radius,
                                  area );
   end if;

   close radius_cursor;
   commit;
end;
/
show errors

select *
  from radius_values;
select *
  from areas;


-- Übung 5
-- 1. Testen Sie das Beispielprogramm.
-- 2. Ändern Sie die Erhöhung des Radius auf Zehnerschritte. Setzen Sie den Startwert auf 10.
-- 3. Der letzte Radiuswert in der Tabelle areas soll 1000 sein.
-- 4. Testen Sie das geänderte Programm.

truncate table areas;
declare
   l_pi constant number(9, 7) default 3.1415927;
   l_radius integer(5);
   l_area number(14, 2);
begin
   l_radius := 10;
   loop
      l_area := l_pi * l_radius * l_radius;
      insert into areas values(l_radius, l_area);
      l_radius := l_radius + 10;
      exit when l_radius > 1000;
   end loop;
   commit;
end;
/
select *
from areas;

-- Übung 6
-- 1. Leeren Sie die Tabelle radius_values und fügen Sie folgende Datensätze ein: 3 6 10 15 21 28 36.
-- 2. Ändern Sie den Block aus Übung 3, sodass alle Datensätze aus radius_values abgearbeitet werden.
-- 3. Überprüfen Sie das Ergebnis in areas.
-- 4. Ersetzen Sie den PL/SQL-Block durch eine SQL-Anweisung, die das Gleiche bewirkt (INSERT mit SELECT).
-- Erwartetes Ergebnis:
-- RADIUS AREA
-- ---------------------- ----------------------
-- 3                      28,27                 
-- 6                      113,1                 
-- 10                     314,16                
-- 15                     706,86                
-- 21                     1385,44               
-- 28                     2463,01               
-- 36                     4071,5                

truncate table radius_values;
truncate table areas;
INSERT INTO radius_values (radius)
VALUES (3),
       (6),
       (10),
       (15),
       (21),
       (28),
       (36);

clear screen
declare
   pi constant number(9, 7) := 3.1415927;
   area number(14, 2);
   cursor radius_cursor is
      select * from radius_values;
   radius_row radius_cursor%rowtype;
begin
   open radius_cursor;
   loop
      fetch radius_cursor into radius_row;
      exit when radius_cursor%notfound;
      area := pi * power(radius_row.radius, 2);
      insert into areas values (radius_row.radius, area);
   end loop;
   close radius_cursor;
commit;
end;
/
show errors

select * from areas;

-- Übung 7
-- 1. Testen Sie das Beispielprogramm.
-- 2. Ändern Sie das Beispielprogramm, sodass radius und area nicht in die Tabelle areas eingefügt werden, sondern auf der
-- Konsole ausgegeben werden.
-- 3. Sehen Sie sich die Syntax FOR LOOP an.
-- 4. Ändern Sie das Beispielprogramm, sodass die Radiuswerte absteigend durchlaufen und ausgegeben werden.
-- Erwartetes Ergebnis:
-- 7 153,94
-- 6 113,1
-- 5 78,54
-- 4 50,27
-- 3 28,27
-- 2 12,57
-- 1 3,14

truncate table areas;
declare
   pi constant number(9, 7) default 3.1415927;
   radius integer(5);
   area number(14, 2);
begin
   for radius in reverse 1..7 loop
      area := pi * power(radius, 2);
      dbms_output.put_line(radius || ' ' || area);
   end loop;
commit;
end;
/
select *
from areas;

-- Übung 8
-- 1. Stellen Sie sicher, dass die Tabelle radius_values einige Datensätze enthält.
-- 2. Testen Sie das Beispielprogramm.
-- 3. Sehen Sie sich die Syntax Cursor FOR LOOP an. Aus dem Syntaxdiagramm geht hervor, dass die Deklaration eines
-- Cursornamens auch noch entfallen kann.
-- 4. Ändern Sie das Beispielprogramm, indem Sie einen anonymen Cursor verwenden, also ohne explizite Cursordeklaration.
-- 5. Ersetzen Sie den PL/SQL-Block durch ein INSERT kombiniert mit SELECT, das die gleiche Änderung bewirkt. Testen
-- Sie das Kommando.
-- 6. Ersetzen Sie den PL/SQL-Block und das Anlegen der Tabelle areas, indem Sie das Kommando create table areas_ as
-- select... verwenden. Sehen Sie sich mit desc areas_ die Struktur der erzeugten Tabelle an.
select * from RADIUS_VALUES;

truncate table areas;
declare
   pi constant number(9, 7) default 3.1415927;
   area number(14, 2);
begin
   for radius_row in (
      select * 
         from radius_values
   ) 
   loop
      area := pi * power(radius_row.radius, 2);
      insert into areas values(radius_row.radius, area);
   end loop;
commit;
end;
/
select *
from areas;

truncate table areas;
insert into areas (radius, area)
select radius, power(radius, 2) * 3.1415927
   from radius_values;
select *
from areas;

drop table areas_;
create table areas_ as
select radius, power(radius, 2) * 3.1415927 as area
   from radius_values;
desc areas_;

-- Übung 9a
-- 1. Sehen Sie sich die Syntax WHILE LOOP an.
-- 2. Ändern Sie das Beispielprogramm von Übung 5, indem Sie eine while Schleife verwenden.
truncate table areas;
declare
   l_pi constant number(9, 7) default 3.1415927;
   l_radius integer(5);
   l_area number(14, 2);
begin
   l_radius := 3;
   l_area := 0;
   while l_area < 100
   loop
      l_area := l_pi * l_radius * l_radius;
      insert into areas values(l_radius, l_area);
      l_radius := l_radius + 1;
   end loop;
commit;
end;
/
select *
from areas;

-- Übung 12
-- Gegeben ist folgender fehlerhafter PL/SQL Programmcode:

declare
   grade integer;
begin
   grade := 5;
   case grade
      when 1 then dbms_output.put_line('Sehr gut');
      when 2 then dbms_output.put_line('Gut');
      when 3 then dbms_output.put_line('Befriedigend');
      when 4 then dbms_output.put_line('Genügend');
      when 5 then dbms_output.put_line('Nicht genügend');
   end case;
end;
/


-- Übung 13
-- 1. Probieren Sie das Codebeispiel im Text aus.
-- 2. Ändern Sie das Beispiel, sodass die Schleife bis 8 läuft.
-- 3. Was passiert, wenn i den Wert 8 enthält? Warum?
-- 4. Ändern Sie das Beispiel, sodass bei ungültigen Werten kein Laufzeitfehler auftritt.
-- 5. Ändern Sie das Beispiel, sodass CASE als Ausdruck und nicht als Anweisung verwendet wird.

declare
  i integer;
begin
for i in 1..8 loop
   case
     when i = 1 then dbms_output.put_line('Montag: 8-12 und 13-18 Uhr.');
     when i = 2 then dbms_output.put_line('Dienstag: 8-13 Uhr.');
     when i = 3 then dbms_output.put_line('Mittwoch: 9-12 Uhr und 14-20 Uhr.');
     when i = 4 then dbms_output.put_line('Donnerstag: 9-13 Uhr.');
     when i = 5 then dbms_output.put_line('Freitag: 10-15 Uhr.');
     when i = 6 then dbms_output.put_line('Samstag: 7-11 Uhr.');      
     when i = 7 then dbms_output.put_line('Sonntag: geschlossen.');
     else dbms_output.put_line('Ungültiger Wochentag.');
   end case;
end loop;
end;