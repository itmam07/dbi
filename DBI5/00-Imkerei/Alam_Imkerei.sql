-- author: Itmam Alam
-- date: 29.09.2025
-- file: Alam_Imkerei.sql

use Imkerei;

--1) Geben Sie die Betriebsnummer und den Namen aller Landwirtschaftsbetriebe an, die als Haupterzeugnis 'Mais' haben 
--   und von der Betriebsform 'GmbH' sind. 
--   Sortieren Sie die Ausgabe aufsteigend nach dem Namen des Landwirtschaftsbetriebes

Select * 
From Landwirtschaftsbetrieb
Where Haupterzeugnis = 'Mais' 
	and Betriebsform = 'GmbH'
Order By Name ASC;


--4) Geben Sie die Imkernummer und Namen des Imkers bzw. der Imkerin an, 
--   der bzw. die durchschnittlich am meisten für angestellte Hilfsarbeitende zahlt.

Select TOP 1 i.ImkerNr, i.Name, AVG(Lohn) as Durchschnittslohn
From Imker i
Join Hilfsarbeiter h 
	on i.ImkerNr = h.stelltAn
Group By i.ImkerNr, i.Name
Order By Durchschnittslohn DESC;

--7) Geben Sie die Namen aller Imker und ihrer Bienenstock Typen und Stocknummern aus, falls diese Bienenstöcke einen 
--   Honigertrag von 300kg oder mehr haben und mindestens 3 Brutnester besitzen.

Select i.Name, b.Typ, b.StockNr
From Imker i
Join Bienenstock b 
	on i.ImkerNr = b.zustaendigFuer
Join Brutnest br 
	on b.Typ = br.liegtInTyp 
 and b.StockNr = br.liegtInStockNr
Where b.Honigertrag > 300 and br.NestNr >= 3
Group By i.Name, b.Typ, b.StockNr;

--10) Geben Sie alle Bienenstöcke (StockNr und Typ) aus, deren Arbeiterinnen weniger als 10 Felder bestäuben und 
--    die maximal 2 Brutnester besitzen, deren Honigertrag aber durchschnittlich oder besser 
--    (im Vergleich zu allen Bienenstöcken) ist. Ordnen Sie die aufsteigend Ergebnisse nach der Stocknummer.

Select bs.StockNr, bs.Typ
From Bienenstock bs
Join Brutnest br
  on bs.StockNr = br.liegtInStockNr
 and bs.Typ = br.liegtInTyp
Join Arbeiterin a 
  on bs.StockNr = a.arbeitetInStockNr 
 and bs.Typ = a.arbeitetInTyp
Join bestaeubt bst
  on a.Kennzahl = bst.Kennzahl
Where bs.Honigertrag >= (Select AVG(bs2.Honigertrag) From Bienenstock bs2)
Group By bs.StockNr, bs.Typ
Having count(distinct br.NestNr) <= 2 and count(distinct bst.Feldkennzahl) < 10
Order By bs.StockNr;


--13) Geben Sie die Kennzahl und Gattung aller Arbeiterinnen an, die entweder in Bienenstöcken mit mehr als 60 Bienen 
--    (inklusive Königin!) arbeiten, und/oder die in Bienenstöcken mit 5 oder mehr Brutnestern arbeiten. 
--    Es genügt wenn jeweils eine Bedingung erfüllt ist.

Select B.StockNr, B.Typ
From Bienenstock B
Join Arbeiterin A
  on A.arbeitetInTyp = B.Typ 
 and A.arbeitetInStockNr = B.StockNr
Join Brutnest BR
  on B.Typ = BR.liegtInTyp
 and B.StockNr = BR.liegtInStockNr
Group By B.StockNr, B.Typ
Having count(A.Kennzahl) > 60
    or count(distinct BR.NestNr) >= 5; 
