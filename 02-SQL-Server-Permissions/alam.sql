Create login alamitmam with password = 'StrongPassword!';
Create user alamitmam for login alamitmam;

ALTER SERVER ROLE dbcreator ADD MEMBER alamitmam;

-- SIRIUS is computer name
CREATE Login [SIRIUS\Verkauf] FROM WINDOWS;
CREATE Login [SIRIUS\Marketing] FROM WINDOWS;

CREATE DATABASE VerkaufsDB ON 
( NAME = VerkaufsDB_Data, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\VerkaufsDB.mdf', SIZE = 10MB ), 
( NAME = VerkaufsDB_Logg, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\VerkaufsDB_log1.ldf', SIZE = 10MB );

CREATE DATABASE MarketingDB ON 
( NAME = MarketingDB_Data, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MarketingDB.mdf', SIZE = 10MB ), 
( NAME = MarketingDB_Logg, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MarketingDB_log1.ldf', SIZE = 10MB );

USE MarketingDB;
CREATE USER [Marketing] FOR LOGIN [SIRIUS\Marketing];
ALTER ROLE db_owner ADD MEMBER [Marketing];

USE VerkaufsDB;
CREATE USER [Marketing] FOR LOGIN [SIRIUS\Marketing];
ALTER ROLE db_datareader ADD MEMBER [Marketing];
