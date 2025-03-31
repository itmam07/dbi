use UDF_Flugzeug;

drop table if exists fliegt 
drop table if exists pilot 
drop table if exists flugzeug 
drop table if exists ftype 
drop table if exists flug 
drop table if exists flughafen 
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
insert into pilot values (3, 'M�ller','Anton',null,'1519270386')

insert into ftype values (1, 'B737', 15000,230)
insert into ftype values (2, 'A320', 12000,120)

insert into flugzeug values (1,'OE123','2013-10-03', 1)
insert into flugzeug values (2,'OE453','2014-01-03', 1)
insert into flugzeug values (3,'OE657','2011-05-23', 2)

insert into flughafen values (1, 'AAL','Denmark')
insert into flughafen values (2, 'ADL','Australien')
insert into flughafen values (3, 'AGX','Indien')
insert into flughafen values (4, 'VIE','�sterreich')

insert into flug values (1,1,2)
insert into flug values (2,2,1)
insert into flug values (3,1,3)
insert into flug values (4,3,1)

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

Create or Alter Function udfSVNRpruefen(@SVNR varchar(10))
returns bit
as
begin

Declare @ok bit = 1;

Declare @z1 int = cast(SUBSTRING(@SVNR, 1, 1) as int),
		@z2 int = cast(SUBSTRING(@SVNR, 2, 1) as int),
		@z3 int = cast(SUBSTRING(@SVNR, 3, 1) as int),
		@z4 int = cast(SUBSTRING(@SVNR, 4, 1) as int),
		@z5 int = cast(SUBSTRING(@SVNR, 5, 1) as int),
		@z6 int = cast(SUBSTRING(@SVNR, 6, 1) as int),
		@z7 int = cast(SUBSTRING(@SVNR, 7, 1) as int),
		@z8 int = cast(SUBSTRING(@SVNR, 8, 1) as int),
		@z9 int = cast(SUBSTRING(@SVNR, 9, 1) as int),
		@z10 int= cast(SUBSTRING(@SVNR, 10, 2) as int);

Declare @laufendeNr char(3) = SUBSTRING(@SVNR, 1, 3);
Declare @pruefziffer char(1) = SUBSTRING(@SVNR, 4, 1);

if (@laufendeNr < 100 or @laufendeNr > 999)
	begin
	set @ok = 0;
	end

Declare @sum int = 3*@z1 + 7*@z2 + 9*@z3 + 5*@z5 + 8*@z6 + 4*@z7 + 2*@z8 + @z9 + 6*@z10;

if (@sum % 11 != @pruefziffer)
	begin
	set @ok = 0;
	end

return @ok
end
go

Select dbo.udfSVNRpruefen('5104140350');
go

-- 2.
Create or Alter Function udfGebdat(@SVNR varchar(10))
returns date
as
begin

Declare @Tag int = cast(substring(@SVNR, 5, 2) as int);
Declare @Monat int = cast(substring(@SVNR, 7, 2) as int);
Declare @Jahr int = cast(substring(@SVNR, 9, 2) as int);

if @Jahr < 25
	Set @Jahr = 2000 + @Jahr;
else
	Set @Jahr = 1900 + @Jahr;

return datefromparts(@Jahr, @Monat, @Tag)
end
go

Select dbo.udfGebdat('5104140350');
go

-- 3.
Create or Alter Procedure stpGebDatSpeichern
	@SVNR varchar(10)
as
begin

	if dbo.udfSVNRpruefen(@SVNR) = 1
		begin
			print 'Ungültige SVNR!';
			return;
		end

	Declare @GebDat date = dbo.udfGebdat(@SVNR);

	if @GebDat is null
		begin
			print 'Ungültiges Datum!';
			return;
		end

	Update pilot
	Set pgebdat = @GebDat
	Where substring(svnr, 1, 4) = substring(@SVNR, 1, 4)

end
go

Select * From pilot;
go

exec stpGebDatSpeichern @SVNR = '5104010100';

Select * From pilot;
go
