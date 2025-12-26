  
insert into Annahme values(1, '2345','Prigglitz','Prigglitz 1');
insert into Annahme values(2, '2334','Gloggnitz','Josefgasse 34');
insert into Annahme values(3, '2500','Baden','Hauptstr. 23');
insert into Annahme values(4, '2700','Wr. Neustadt','Wienerstr. 124');
select * from Annahme;
commit;

insert into OEFFNUNGSZEIT values(1,'MO','08:00','16:00');
insert into OEFFNUNGSZEIT values(1,'MI','08:00','18:00');
insert into OEFFNUNGSZEIT values(1,'DO','09:00','17:00');
insert into OEFFNUNGSZEIT values(1,'FR','09:30','19:00');
insert into OEFFNUNGSZEIT values(1,'SA','08:00','15:00');

insert into OEFFNUNGSZEIT values(2,'MO','08:00','16:00');
insert into OEFFNUNGSZEIT values(2,'MI','08:00','18:00');
insert into OEFFNUNGSZEIT values(2,'DO','09:00','17:00');
insert into OEFFNUNGSZEIT values(2,'FR','09:30','19:00');
insert into OEFFNUNGSZEIT values(2,'SA','08:00','15:00');

insert into OEFFNUNGSZEIT values(3,'MO','08:00','16:00');
insert into OEFFNUNGSZEIT values(3,'MI','08:00','18:00');
insert into OEFFNUNGSZEIT values(3,'DO','09:00','17:00');
insert into OEFFNUNGSZEIT values(3,'FR','09:30','19:00');
insert into OEFFNUNGSZEIT values(3,'SA','08:00','15:00');

insert into OEFFNUNGSZEIT values(4,'MO','08:00','16:00');
insert into OEFFNUNGSZEIT values(4,'MI','08:00','18:00');
insert into OEFFNUNGSZEIT values(4,'DO','09:00','17:00');
insert into OEFFNUNGSZEIT values(4,'FR','09:30','19:00');
insert into OEFFNUNGSZEIT values(4,'SA','08:00','15:00');
select * from OEFFNUNGSZEIT;

insert into ziehung values(to_date('2018-11-21','YYYY-MM-DD'),1,2,3,4,5,6,23);

commit;
/