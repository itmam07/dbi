-- author: Itmam Alam
-- date: 17-10-2025
use Indices_03
go

-- Task 1 (filtering and sorting)
SET STATISTICS IO, TIME ON;
SELECT TOP (20) p.ProductID, p.SKU, p.[Name], p.Price, p.Stock
FROM dbo.Product p
WHERE p.Category = N'Elektronik'
 AND p.Price BETWEEN 100 AND 300
 AND p.Stock > 0
ORDER BY p.Price, p.ProductID;

-- composite/covering index 
-- because we are sorting by price and filtering by Category, Stock and price
CREATE NONCLUSTERED INDEX idx_product_cat_price_stock
ON [dbo].[Product] ([Category],[Price],[Stock]) 
INCLUDE ([SKU],[Name])


-- Task 2 (joins and aggregations)
DECLARE @d DATETIME2 = DATEADD(MONTH, -6, SYSUTCDATETIME());
SELECT TOP (10) o.CustomerID,
 SUM(oi.Quantity * oi.UnitPrice) AS Umsatz
FROM dbo.[Order] o
JOIN dbo.OrderItem oi ON o.OrderID = oi.OrderID
WHERE o.OrderDate >= @d
 AND o.Status IN ('Processing','Shipped')
GROUP BY o.CustomerID
ORDER BY Umsatz DESC;

-- composite/covering index
-- two indexes on Order and OrderItem
CREATE INDEX IX_Order_OrderDate_Status
    ON dbo.[Order] (OrderDate, Status)
    INCLUDE (OrderID, CustomerID);

CREATE INDEX IX_OrderItem_OrderID
    ON dbo.OrderItem (OrderID)
    INCLUDE (Quantity, UnitPrice);

-- Task 3 (pagination and filtering)
SET STATISTICS IO, TIME ON;
SELECT o.OrderID, o.CustomerID, o.OrderDate, o.Status
FROM dbo.[Order] o
WHERE o.Status IN ('Processing','Pending')
 AND o.OrderDate >= DATEADD(DAY, -30, SYSUTCDATETIME())
ORDER BY o.OrderDate DESC, o.OrderID DESC
OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY;

-- composite/covering index
CREATE INDEX IX_Order_Status_OrderDate
    ON dbo.[Order] (Status, OrderDate DESC, OrderID DESC);
