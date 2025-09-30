use Lager;

drop table if exists lieferung;
drop table if exists lager;
drop table if exists product;

create table product (
    ProdNr int primary key,
    Description varchar(100)
);
go

create table lager (
    LNr int primary key,
    Ort varchar(100),
    StueckKap int
);
go

create table lieferung (
    LNr int references lager(LNr),
    LfndNr int identity(1,1) primary key,
    ANr int,
    Datum datetime,
    Stueck int
);
go

INSERT INTO product (ProdNr, Description)
VALUES 
(1, 'Laptop Dell XPS 13'),
(2, 'Samsung Galaxy S23'),
(3, 'Sony Noise Cancelling Headphones'),
(4, 'Apple MacBook Pro 16'),
(5, 'Logitech MX Master 3 Mouse');
go

INSERT INTO lager (LNr, Ort, StueckKap)
VALUES 
(1, 'Lager Berlin', 500),
(2, 'Lager Hamburg', 300),
(3, 'Lager München', 700),
(4, 'Lager Köln', 400),
(5, 'Lager Stuttgart', 600);
go

INSERT INTO lieferung (LNr, ANr, Datum, Stueck)
VALUES 
(1, 1001, '2025-01-10 08:00:00', 150),  -- Lieferung für Bestellung 1001 ins Lager Berlin
(1, 1001, '2024-01-11 09:00:00', 150),  -- Zweite Teillieferung für Bestellung 1001
(2, 1002, '2021-02-15 10:30:00', 200),  -- Lieferung für Bestellung 1002 ins Lager Hamburg
(3, 1003, '2024-03-20 14:15:00', 300),  -- Lieferung für Bestellung 1003 ins Lager München
(4, 1004, '2023-04-05 16:45:00', 250);  -- Lieferung für Bestellung 1004 ins Lager Köln
go

create or alter procedure Anlieferung
	@ANr integer, 
	@Datum datetime, 
	@Stueck integer
as
Begin
	declare @LNr int, @StueckKap int;
	declare @CurrentStueck int = @Stueck;

	declare @ResultTable table (
		LNr int,
		Stueck int
	)

	declare LagerCursor cursor
	for select LNr, StueckKap from lager;

	Open LagerCursor;
	Fetch Next From LagerCursor Into @LNr, @StueckKap;

	While @@FETCH_STATUS = 0 And @CurrentStueck > 0
	Begin
		if @CurrentStueck <= @StueckKap  -- wenn die restliche anzahl kleiner ist oder ausreicht
			Begin
				Insert Into @ResultTable Values (@LNr, @CurrentStueck);
				Set @CurrentStueck = 0;
			End
		else  -- wenn die restliche anzahl größer ist als die kapazität
			Begin
				Insert Into @ResultTable Values (@LNr, @StueckKap);
				Set @CurrentStueck -= @StueckKap;
			End

		Fetch Next From LagerCursor Into @LNr, @StueckKap;
	End

	Close LagerCursor;
	Deallocate LagerCursor;

	if @CurrentStueck > 0
		Begin
			Delete From @ResultTable;
		End

	Insert Into lieferung (LNr, ANr, Datum, Stueck)
	Select r.LNr, @ANr, @Datum, r.Stueck
	From @ResultTable r

	Select * From @ResultTable;
End
go

exec Anlieferung @ANr = 1005, @Datum = '10.10.1994', @Stueck = 2500;
go

Create or Alter Procedure Entnahme
	@ANr int,
	@Stueck int
As 
Begin
	-- Initialisierung
	Declare @ResultTable table
	(LNr int, Stueck int);
	
	-- Bestandsprüfung
	Declare @TotalKap int; 
	Select @TotalKap = SUM(Stueck) From lieferung;

	If @TotalKap < @Stueck
	Begin
		Select * From @ResultTable;
		Return;
	End
	
	-- Sortierung nach Alter und Entnahme
	Declare LieferungCursor Cursor 
	For Select LNr, Stueck, Datum
		From lieferung 
		Order By Datum;

	Declare @LNrCursor int, @StueckCursor int, @DatumCursor datetime;

	Open LieferungCursor;
	Fetch Next From LieferungCursor Into @LNrCursor, @StueckCursor, @DatumCursor;

	Declare @CurrentStueck int = @Stueck;

	While @@FETCH_STATUS = 0 and @CurrentStueck > 0
	Begin
		
		If @CurrentStueck <= @StueckCursor
		Begin
			Insert Into @ResultTable Values (@LNrCursor, @CurrentStueck);

			Update lieferung 
			Set Stueck = Stueck - @CurrentStueck
			Where LNr = @LNrCursor and Datum = @DatumCursor;

			Set @CurrentStueck = 0;
		End

		Else
		Begin
			Insert Into @ResultTable Values (@LNrCursor, @StueckCursor);

			Update lieferung 
			Set Stueck = Stueck - @CurrentStueck
			Where LNr = @LNrCursor and Datum = @DatumCursor;

			Set @CurrentStueck -= @StueckCursor;
		End

		Fetch Next From LieferungCursor Into @LNrCursor, @StueckCursor, @DatumCursor;
	End

	Close LieferungCursor;
	Deallocate LieferungCursor;

	Select * From @ResultTable
End
go

Exec Entnahme @ANr = 1, @Stueck = 1050;
go


Create or Alter Procedure LagerLoeschen
	@LNr int
As 
Begin
	Delete From lieferung
	Where LNr = @LNr;

	Delete From lager
	Where LNr = @LNr;
End
go

exec LagerLoeschen @LNr = 1;
go
