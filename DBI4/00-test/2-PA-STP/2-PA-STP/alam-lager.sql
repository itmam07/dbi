/*
 * author: itmam alam
 * file: alam-lager.sql
**/

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

Create or Alter Procedure Anlieferung
    @ANr int,
    @Datum datetime,
    @Stueck int
As
Begin
    Declare @remaining int = @Stueck;

    Create Table #Result (LNr int, Stueck int);

    Declare @LNr int, @FreierPlatz int;

    Declare cur_lager Cursor For
    Select l.LNr, l.StueckKap - IsNull(Sum(li.Stueck), 0) As FreierPlatz
    From lager l
    Left Join lieferung li On l.LNr = li.LNr
    Group By l.LNr, l.StueckKap
    Having l.StueckKap - IsNull(Sum(li.Stueck), 0) > 0
    Order By l.LNr;

    Open cur_lager;
    Fetch Next From cur_lager Into @LNr, @FreierPlatz;

    While @remaining > 0 And @@FETCH_STATUS = 0
    Begin
        Declare @allocate int = Case When @remaining > @FreierPlatz Then @FreierPlatz Else @remaining End;

        Insert Into lieferung (LNr, ANr, Datum, Stueck)
        Values (@LNr, @ANr, @Datum, @allocate);

        Insert Into #Result (LNr, Stueck)
        Values (@LNr, @allocate);

        Set @remaining = @remaining - @allocate;

        Fetch Next From cur_lager Into @LNr, @FreierPlatz;
    End

    Close cur_lager;
    Deallocate cur_lager;

    If @remaining > 0
    Begin
        Delete From lieferung Where ANr = @ANr;
        Truncate Table #Result;
    End

    Select * From #Result;
End
Go

Create or Alter Procedure Entnahme
    @ANr int,
    @Stueck int
As
Begin
    Declare @remaining int = @Stueck;

    Create Table #Result (LNr int, Stueck int);

    Declare @LNr int, @LfndNr int, @currentStueck int;

    Declare cur_entnahme Cursor For
    Select LNr, LfndNr, Stueck
    From lieferung
    Where ANr = @ANr
    Order By Datum;

    Open cur_entnahme;
    Fetch Next From cur_entnahme Into @LNr, @LfndNr, @currentStueck;

    While @remaining > 0 And @@FETCH_STATUS = 0
    Begin
        If @remaining >= @currentStueck
        Begin
            Delete From lieferung Where LfndNr = @LfndNr;

            Insert Into #Result (LNr, Stueck)
            Values (@LNr, @currentStueck);

            Set @remaining = @remaining - @currentStueck;
        End
        Else
        Begin
            Update lieferung
            Set Stueck = Stueck - @remaining
            Where LfndNr = @LfndNr;

            Insert Into #Result (LNr, Stueck)
            Values (@LNr, @remaining);

            Set @remaining = 0;
        End

        Fetch Next From cur_entnahme Into @LNr, @LfndNr, @currentStueck;
    End

    Close cur_entnahme;
    Deallocate cur_entnahme;

    If @remaining > 0
    Begin
        Truncate Table #Result;
    End

    Select * From #Result;
End
Go

create or Alter procedure LagerLoeschen
    @LNr int
as
begin
    begin try
        delete from lieferung where LNr = @LNr;
        delete from lager where LNr = @LNr;
    end try
    begin catch
    end catch
end
go

Create or Alter Procedure Bestand
As
Begin
    Select 
        p.description As Bezeichnung, 
        l.Ort, 
        li.Datum, 
        li.Stueck
    From 
        lieferung li
    Join 
        lager l On li.LNr = l.LNr
    Join 
        product p On li.ANr = p.prodnr
    Order By 
        p.description, l.Ort, li.Datum;
    
    Select 
        p.description As Bezeichnung, 
        l.Ort, 
        '*** Summe' As Datum, 
        Sum(li.Stueck) As Stueck
    From 
        lieferung li
    Join 
        lager l On li.LNr = l.LNr
    Join 
        product p On li.ANr = p.prodnr
    Group By 
        p.description, l.Ort
    Order By 
        p.description, l.Ort;
End
Go

Create or Alter Procedure lagbest
    @LNr int
As
Begin
    -- Tabelle mit den Lagerdaten
    Select 
        Ort, 
        StueckKap 
    From 
        lager 
    Where 
        LNr = @LNr;

    -- Tabelle mit dem Artikelbestand des Lagers
    Select 
        p.description As Bezeichnung, 
        Sum(li.Stueck) As Bestand
    From 
        lieferung li
    Join 
        product p On li.ANr = p.prodnr
    Where 
        li.LNr = @LNr
    Group By 
        p.description;
End
Go

Create or Alter Procedure lagbestmulti
    @ANr int
As
Begin
    -- Tabelle pro Lager, in der der Artikel vorkommt
    Declare cur_lager Cursor For
        Select Distinct l.LNr, l.Ort
        From lieferung li
        Join lager l On li.LNr = l.LNr
        Where li.ANr = @ANr;

    Declare @LNr int, @Ort varchar(50);

    Open cur_lager;
    Fetch Next From cur_lager Into @LNr, @Ort;

    While @@FETCH_STATUS = 0
    Begin
        Print 'Lager: ' + @Ort; -- Ausgabe der Tabelle für das Lager
        Select 
            l.Ort, 
            p.description As Bezeichnung, 
            Sum(li.Stueck) As Bestand
        From 
            lieferung li
        Join 
            lager l On li.LNr = l.LNr
        Join 
            product p On li.ANr = p.prodnr
        Where 
            l.LNr = @LNr
        Group By 
            l.Ort, p.description;

        Fetch Next From cur_lager Into @LNr, @Ort;
    End;

    Close cur_lager;
    Deallocate cur_lager;
End
Go


Insert Into product Values (1, 'Schrauben');
Insert Into product Values (2, 'Nägel');
Insert Into product Values (3, 'Muttern');

Insert Into lager Values (1, 'Wien', 500);
Insert Into lager Values (2, 'Graz', 300);
Insert Into lager Values (3, 'Linz', 200);
Insert Into lager Values (4, 'Salzburg', 100);

Insert Into lieferung (LNr, ANr, Datum, Stueck) Values (1, 1, '2024-01-01', 100); 
Insert Into lieferung (LNr, ANr, Datum, Stueck) Values (2, 2, '2024-01-02', 50);  
Insert Into lieferung (LNr, ANr, Datum, Stueck) Values (2, 3, '2024-01-03', 80);  
Insert Into lieferung (LNr, ANr, Datum, Stueck) Values (3, 4, '2024-01-04', 60);

exec Anlieferung @ANr = 1, @Datum = '2024-01-01', @Stueck = 100;
exec Entnahme @ANr = 1, @Stueck = 50;
exec LagerLoeschen @LNr = 1;
exec Bestand;
exec lagbest @LNr = 1;
exec lagbestmulti @ANr = 1;
