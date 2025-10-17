
SET NOCOUNT ON;

---------------------------------------------
-- 0) Aufräumen 
---------------------------------------------
DROP TABLE IF EXISTS dbo.OrderItem;
DROP TABLE IF EXISTS dbo.[Order];
DROP TABLE IF EXISTS dbo.Product;
GO

---------------------------------------------
-- 1) Tabellen
---------------------------------------------
CREATE TABLE dbo.Product
(
    ProductID INT IDENTITY PRIMARY KEY,
    SKU       VARCHAR(40)   NOT NULL,
    [Name]    NVARCHAR(200) NOT NULL,
    Category  NVARCHAR(100) NOT NULL,
    Price     DECIMAL(10,2) NOT NULL,
    Stock     INT NOT NULL
);
GO

CREATE TABLE dbo.[Order]
(
    OrderID    INT IDENTITY PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate  DATETIME2(0) NOT NULL,
    Status     VARCHAR(20)  CHECK (Status IN ('Pending','Processing','Shipped','Cancelled'))
);
GO

CREATE TABLE dbo.OrderItem
(
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID     INT NOT NULL FOREIGN KEY REFERENCES dbo.[Order](OrderID),
    ProductID   INT NOT NULL FOREIGN KEY REFERENCES dbo.Product(ProductID),
    Quantity    INT NOT NULL,
    UnitPrice   DECIMAL(10,2) NOT NULL
);
GO

---------------------------------------------
-- 2) Demodaten
-- ca. 20.000 Produkte, 5.000 Orders, 20.000 Positionen
---------------------------------------------
;WITH n AS (
  SELECT TOP (40000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
  FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
-- Produkte (20.000)
INSERT INTO dbo.Product(SKU,[Name],Category,Price,Stock)
SELECT 
  CONCAT('SKU', RIGHT('000000' + CAST(n AS VARCHAR(6)), 6)),
  CONCAT(N'Produkt ', n),
  CHOOSE(1 + (n % 8), N'Hardware',N'Software',N'Elektronik',N'Bücher',N'Haushalt',N'Sport',N'Garten',N'Spielwaren'),
  5 + (n % 500),
  n % 1000
FROM n
WHERE n <= 20000;

-- Orders (≈5.000)
INSERT INTO dbo.[Order](CustomerID,OrderDate,Status)
SELECT TOP (5000)
  (ABS(CHECKSUM(NEWID())) % 500) + 1,
  DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, SYSUTCDATETIME()),
  CHOOSE(1 + (ABS(CHECKSUM(NEWID())) % 4),'Pending','Processing','Shipped','Cancelled')
FROM sys.all_objects;

-- OrderItems (≈20.000) – **IDs werden aus existierenden Tabellen gezogen**
INSERT INTO dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice)
SELECT TOP (20000)
  o.OrderID,
  p.ProductID,
  1 + (ABS(CHECKSUM(NEWID())) % 5),
  CAST(5 + (ABS(CHECKSUM(NEWID())) % 500) AS DECIMAL(10,2))
FROM sys.all_objects s
CROSS APPLY (SELECT TOP 1 OrderID  FROM dbo.[Order]  ORDER BY NEWID()) o
CROSS APPLY (SELECT TOP 1 ProductID FROM dbo.Product ORDER BY NEWID()) p;

Select * From Product
Select * From dbo.[Order];
Select * From OrderItem;