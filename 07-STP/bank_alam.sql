/*
 * author: Itmam Alam
 * file: bank_alam.sql
 * date: 04.12.2024
**/

use Bank;
go

-- a.) prcFaelligeTANBlaetter (BLZ)

create or alter procedure prcFaelligeTANBlaetter
	@BLZ int
as
begin
	Select k.KontoNr
	From Konto k
	Join Kunde ku
		on k.KundenNr = ku.KundenNr
	Left Join TanBlatt t
		on ku.KundenNr = t.KundenNr
	Where k.BLZ = @BLZ and t.TAN_Status = 0
	Group By k.KontoNr
	Having Count(*) < 10

end
go

exec prcFaelligeTANBlaetter 1;
go

-- b.) prcTANERZEUGEN (BLZ, KontoNr)
create or alter procedure prcTANErzeugen
	@BLZ int,
	@KontoNr int
as
begin
	-- get data
	declare @KundenNr int
    select @KundenNr = KundenNr 
	from Konto 
	where BLZ = @BLZ and KontoNr = @KontoNr

	declare @BlattNr int
    select @BlattNr = isnull(max(blattNr), 0) + 1 -- immer eins mehr als existieren
	from TanBlatt 
	where KundenNr = @KundenNr

	-- invalidate existing tans
	update TanBlatt
    set TAN_Status = 2
    where KundenNr = @KundenNr and TAN_Status = 0

	-- create new random tans
	declare @i int = 1
    while @i <= 50
    begin
        insert into tanblatt (kundenNr, blattNr, blattIndex, ziffernfolge, tan_status)
        values (
            @kundenNr,
            @blattNr,
            cast(@i as varchar),
            cast(floor(rand() * 1000000) as char(6)),  -- floor (abrunden) sonst funktioniert cast nicht
            0
        )
        set @i = @i + 1
    end
end
go

exec prcTANErzeugen @BLZ = 1, @KontoNr = 102;
go

-- c.) prcUEBERWEISEN (BLZ Absendekonto, KtoNr Absendekonto, BLZ Empfängerkonto, KtoNr Empfängerkonto, Betrag, Buchungstext, TAN)
create or alter procedure prcUeberweisen
    @BLZ_Absendekonto int,
    @KontoNr_Absendekonto int,
    @BLZ_EmpfaengerKonto int,
    @KontoNr_EmpfaengerKonto int,
    @Betrag decimal(8,2),
    @Buchungstext varchar(35),
    @TAN char(6)
as
begin
    declare @KundenNr_Absender int, @KundenNr_Empfaenger int
    declare @TAN_Status int

	-- check if given tan is correct
    select @TAN_Status = tan_status
    from TANBlatt
    where KundenNr = (select KundenNr from Konto where BLZ = @BLZ_Absendekonto and KontoNr = @KontoNr_Absendekonto)  
      and Ziffernfolge = @TAN
    
    if @TAN_Status is null or @TAN_Status != 0
    begin
        print 'TAN not correct'
		return
    end

	-- check if both kunden exist
    select @KundenNr_Absender = KundenNr 
	from Konto
    where BLZ = @BLZ_Absendekonto and 
		  KontoNr = @KontoNr_Absendekonto

    select @KundenNr_Empfaenger = KundenNr 
	from Konto
    where BLZ = @BLZ_EmpfaengerKonto and 
		  KontoNr = @KontoNr_EmpfaengerKonto

    if @KundenNr_Absender is null or @KundenNr_Empfaenger is null
    begin
        print 'Sender or Receiver not correct'
		return
    end

	-- beign transaction
	-- invalidate TAN
    update TANBlatt
    set TAN_Status = 1
    where KundenNr = @KundenNr_Absender and Ziffernfolge = @TAN

	-- gutschrift
    insert into Kontobewegung (BLZ, KontoNr, Buchungszeile, Buchungstext, Betrag, Datum)
    values (@BLZ_EmpfaengerKonto, @KontoNr_EmpfaengerKonto, 
           (select max(Buchungszeile) + 1 -- erhöhe Bu.Zeile  um eins
			 from Kontobewegung 
			 where BLZ = @BLZ_Absendekonto and 
				   KontoNr = @KontoNr_Absendekonto),  
            @Buchungstext, -@Betrag, getdate())

	-- lastschrift
    insert into Kontobewegung (BLZ, KontoNr, Buchungszeile, Buchungstext, Betrag, Datum)
    values (@BLZ_Absendekonto, @KontoNr_Absendekonto, 
           (select max(Buchungszeile) + 1 -- erhöhe Bu.Zeile  um eins
			 from Kontobewegung 
			 where BLZ = @BLZ_Absendekonto and 
				   KontoNr = @KontoNr_Absendekonto),  
            @Buchungstext, -@Betrag, getdate())
end
go

exec prcUEBERWEISEN
    @BLZ_Absendekonto = 1,
    @KontoNr_Absendekonto = 102,
	@BLZ_EmpfaengerKonto = 2,    
    @KontoNr_EmpfaengerKonto = 200,
    @Betrag = 1000.00,
    @Buchungstext = 'Überweisung für Miete',
    @TAN = '18401'
;
go

-- d. prcKontostand (BLZ, Kontonummer)
create or alter procedure prcKontostand
	@BLZ int,
	@Kontonummer int
as
begin
	Select Datum,
		   (Select sum(Betrag)
		    From Kontobewegung k2
			Where k2.Blz = k1.Blz and 
				  k2.KontoNr = k1.KontoNr and
				  (k2.Datum < k1.Datum or  -- anderer tag => ok
				  (k2.Datum = k1.Datum and k2.Buchungszeile <= k1.Buchungszeile))  -- selber tag => muss andere bu.zeile haben
			) as Kontostand
	From Kontobewegung k1
	where BLZ = @BLZ and 
		  KontoNr = @Kontonummer
    order by Datum, Buchungszeile; -- order by bu.zeile wenn mehrere transactions am selebn tag
end
go

exec prcKontostand 2, 204;
go