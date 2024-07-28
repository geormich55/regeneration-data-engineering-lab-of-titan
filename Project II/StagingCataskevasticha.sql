CREATE DATABASE StagingCataskevasticha;
USE StagingCataskevasticha;

-- Staging for Employees

SELECT ProductionEmployeeID, EmployeeName
INTO Employees --Cataskevasticha.dbo.Employees
FROM Cataskevasticha.dbo.ProductionTeam;

SELECT * FROM Employees; --Cataskevasticha.dbo.Employees

-- Staging for Customers

SELECT CustomerID, CustomerName, Email, Phone, CustomerAddress 
INTO Customers --Cataskevasticha.dbo.Customers
FROM Cataskevasticha.dbo.Customers;

SELECT * FROM Customers; --Cataskevasticha.dbo.Customers

-- Staging for RawMaterials (Taking also from Supplier Table)

SELECT rm.RawMaterialID, rm.RawMaterialName, s.SupplierID, s.SupplierName
INTO RawMaterials --Cataskevasticha.dbo.RawMaterials
FROM Cataskevasticha.dbo.RawMaterials rm
LEFT JOIN  Cataskevasticha.dbo.Suppliers s -- LEFT JOIN to keep any products with null SupplierID
ON rm.SupplierID = s.SupplierID;

SELECT * FROM RawMaterials; --Cataskevasticha.dbo.RawMaterials

-- Staging for Products

SELECT ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays, Color
INTO Products --Cataskevasticha.dbo.Products
FROM Cataskevasticha.dbo.Products;

SELECT * FROM Products;


-- Staging for Sales

SELECT ol.ProductSKU, o.OrderID, o.ProductionEmployeeID, o.CustomerID, o.LogisticsPartner, ol.Quantity, 
	o.RequestDate, osh.StatusDate, osh.OrderStatus,
	CASE 
        WHEN DATEADD(DAY, p.ConstructionTimeInDays, CONVERT(DATE, o.RequestDate)) > osh.StatusDate THEN 'In production'
        ELSE 'Completed'
    END AS ProductStatus,
	DATEADD(DAY, p.ConstructionTimeInDays, CONVERT(DATE, o.RequestDate)) as [ProductDoneDate]
INTO Sales
FROM Cataskevasticha.dbo.Orders o
INNER JOIN Cataskevasticha.dbo.OrdersList ol
ON o.OrderID = ol.OrderID
INNER JOIN Cataskevasticha.dbo.OrderStatusHistory osh
ON o.OrderID = osh.OrderID 
INNER JOIN Cataskevasticha.dbo.Products p
ON ol.ProductSKU = p.ProductSKU ;


ALTER TABLE Sales ADD [version] rowversion;
SELECT * FROM Sales;

-- Staging for production

SELECT n.ProductSKU, n.RawMaterialID, n.Quantity
INTO Production
FROM Cataskevasticha.dbo.Needs n;

SELECT * FROM Production;