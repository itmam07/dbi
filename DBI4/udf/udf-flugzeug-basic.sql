use UDF_Flugzeug;

drop table if exists fliegt; 
drop table if exists pilot; 
drop table if exists flugzeug; 
drop table if exists ftype; 
drop table if exists flug; 
drop table if exists flughafen; 
go

create table pilot (
	pnr integer primary key, 
	pnname varchar(30),
	pvname varchar(30),
	pgebdat date,
	svnr char(10)
);

create table ftype (
	tnr integer primary key, 
	bezeichnung varchar(20),
	reichweite integer,
	sitzplaetze integer
);

create table flugzeug (
	fznr int primary key, 
	rufzeichen char(10),
	anschaffungsdat date,
	tnr int references ftype
);

create table flughafen(
	fhnr int primary key, 
	Bezeichnung char(3),
	land varchar(30)
);

create table flug (
	fnr int primary key, 
	splatz int references flughafen, 
	lplatz int references flughafen
);


create table fliegt (
	pnr int references pilot, 
	fznr int references flugzeug, 
	fnr int references flug, 
	startzeit datetime,
	landezeit datetime,
	pzahl int,				--Passagieranzahl 	
	primary key(pnr, fznr, fnr, startzeit)
);
go

insert into pilot values (1, 'Huber','Susi',null,'5104140350')
insert into pilot values (2, 'Maier','Karl',null,'3216230124')
insert into pilot values (3, 'Müller','Anton',null,'1519270386')

insert into ftype values (1, 'B737', 15000,230)
insert into ftype values (2, 'A320', 12000,120)

insert into flugzeug values (1,'OE123','2013-10-03', 1)
insert into flugzeug values (2,'OE453','2014-01-03', 1)
insert into flugzeug values (3,'OE657','2011-05-23', 2)

insert into flughafen values (1, 'AAL','Denmark')
insert into flughafen values (2, 'ADL','Australien')
insert into flughafen values (3, 'AGX','Indien')
insert into flughafen values (4, 'VIE','Österreich')

insert into flug values (1,1,2)
insert into flug values (2,2,1)
insert into flug values (3,1,3)
insert into flug values (4,3,1)
insert into flug values (5,3,1)
insert into flug values (6,4,1)
insert into flug values (7,4,1)
insert into flug values (8,4,1)
insert into flug values (9,4,1)


insert into fliegt(pnr,fznr,fnr,startzeit,landezeit,pzahl) values(1,1,1,'2015-02-01 12:10','2015-02-01 14:10',100)
insert into fliegt values(1,1,2,'2015-02-01 12:10','2015-02-01 14:10',100)
insert into fliegt values(2,2,3,'2016-01-01 12:10','2016-01-01 16:10',100)
insert into fliegt values(2,2,4,'2015-12-12 12:10','2015-12-12 14:20',100)
insert into fliegt values(1,1,1,'2015-12-01 12:10','2015-12-01 14:14',100)
insert into fliegt values(1,1,2,'2015-07-03 02:10','2015-07-03 19:34',100)
insert into fliegt values(2,3,3,'2015-08-05 08:10','2015-08-05 11:50',100)
insert into fliegt values(2,3,4,'2015-09-06 11:10','2015-09-06 17:46',100)

go

-- 1.

Create or Alter Function Flugminuten(@FzNr int)
returns int
as
begin

Declare @total int;

Select @total = sum(datediff(minute, Startzeit, Landezeit))
From fliegt
Where fznr = @FzNr;

return @total;
end
go

Select dbo.Flugminuten(1) as Flugminuten;
go

-- 2.

Create or Alter Function FluegeProTyp()
returns Table
as

return (
	Select p.pnname, ftype.bezeichnung, count(*) as Anzahl
	From fliegt
	Join flugzeug on fliegt.fznr = flugzeug.fznr
	Join ftype on flugzeug.tnr = ftype.tnr
	Join pilot p on fliegt.pnr = p.pnr
	Group By p.pnname, ftype.bezeichnung
);

go

Select * from dbo.FluegeProTyp();
go

-- 3.

Create or Alter Function Flugaufkommen(@ANr int = -1)
returns table
as

return (
	Select 
			f.fhnr, 
			f.Bezeichnung,
			(Select count(*) From flug fl where fl.splatz = f.fhnr) as Abflüge,
			(Select count(*) From flug fl where fl.lplatz = f.fhnr) as Ankünfte
	From flughafen f
	Where @ANr = -1 or f.fhnr = @ANr
);

go

Select * From Flugaufkommen(default);