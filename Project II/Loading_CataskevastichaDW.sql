USE CataskevastichaDW ;

-- Employees load
SELECT * FROM DimEmployee;
SELECT * FROM StagingCataskevasticha.dbo.Employees;

INSERT INTO DimEmployee (EmployeeID, EmployeeName)
SELECT ProductionEmployeeID, EmployeeName
FROM StagingCataskevasticha.dbo.Employees;

SELECT * FROM DimEmployee;

-- Customers load

SELECT * FROM DimCustomer;
SELECT * FROM StagingCataskevasticha.dbo.Customers;

INSERT INTO DimCustomer (CustomerID, CustomerName, Email, Phone,CustomerAddress)
SELECT CustomerID, CustomerName, Email, Phone, CustomerAddress
FROM StagingCataskevasticha.dbo.Customers;

SELECT * from DimCustomer;

--Raw Materials load

SELECT * FROM DimRawMaterial;
SELECT * FROM StagingCataskevasticha.dbo.RawMaterials;

INSERT INTO DimRawMaterial (RawMaterialID, RawMaterialName, SupplierID, SupplierName)
SELECT RawMaterialID, RawMaterialName, SupplierID, SupplierName
FROM StagingCataskevasticha.dbo.RawMaterials;

SELECT * from DimRawMaterial;


-- Product load

SELECT * FROM StagingCataskevasticha.dbo.Products;
SELECT * FROM DimProduct;

INSERT INTO DimProduct (ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays, Color)
SELECT ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays, Color
FROM StagingCataskevasticha.dbo.Products;

SELECT * FROM DimProduct;


-- Create Constraints
USE CataskevastichaDW;

ALTER TABLE FactSales ADD FOREIGN KEY (CustomerKey)
REFERENCES DimCustomer(CustomerKey);

ALTER TABLE FactSales ADD FOREIGN KEY (EmployeeKey)
REFERENCES DimEmployee(EmployeeKey);

ALTER TABLE FactSales ADD FOREIGN KEY (ProductKey)
REFERENCES DimProduct (ProductKey);

ALTER TABLE FactSales ADD FOREIGN KEY (RequestDateKey)
REFERENCEs DimDate(DateKey);

ALTER TABLE FactSales ADD FOREIGN KEY (StatusDateKey)
REFERENCEs DimDate(DateKey);

ALTER TABLE FactProduction ADD FOREIGN KEY (ProductKey)
REFERENCES DimProduct (ProductKey);

ALTER TABLE FactProduction ADD FOREIGN KEY (RawMaterialKey)
REFERENCES DimRawMaterial (RawMaterialKey);

ALTER TABLE FactProduction ADD FOREIGN KEY (StatusDateKey)
REFERENCES DimDate (DateKey);


SELECT * FROM FactSales;
SELECT * FROM StagingCataskevasticha.dbo.Sales;

----------------------------------------------------------------------------------
-- Insert new or updated records into FactSales
INSERT INTO 
	FactSales(EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner, TotalPrice, Row_version)
SELECT top 144
	e.EmployeeKey, c.CustomerKey, s.OrderID, p.ProductKey, 
	CAST(FORMAT(RequestDate,'yyyyMMdd') AS INT) RequestDateKey, 
	CAST(FORMAT(StatusDate,'yyyyMMdd') AS INT) StatusDateKey,
	s.OrderStatus, s.Quantity, s.LogisticsPartner, (Quantity * p.CostPerUnit), CAST(s.[version] AS BIGINT) AS ver
FROM StagingCataskevasticha.dbo.Sales s
	INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	INNER JOIN DimCustomer c ON s.CustomerID = c.CustomerID
	INNER JOIN DimEmployee e ON s.ProductionEmployeeID = e.EmployeeID 
WHERE p.RowIsCurrent = 1 AND c.RowIsCurrent = 1 AND e.RowIsCurrent = 1
ORDER BY ver;

----------------------------------------------------------------------------------------------------------------------------
INSERT INTO 
	FactProduction ( ProductKey, RawMaterialKey, OrderID, ProductStatus, StatusDateKey,Quantity, Row_version)  --Quantity of materials
SELECT top 102
	p.ProductKey, rm.RawMaterialKey,
	s.OrderID, s.ProductStatus,
	CASE 
        WHEN s.ProductStatus = 'In production' 
		THEN CAST(FORMAT(s.RequestDate,'yyyyMMdd') AS INT)
        ELSE CAST(FORMAT(s.ProductDoneDate,'yyyyMMdd') AS INT)
    END AS StatusDate,
	pr.Quantity, CAST(s.[version] AS BIGINT) as ver
FROM StagingCataskevasticha.dbo.Sales s
	INNER JOIN StagingCataskevasticha.dbo.Production pr ON s.ProductSKU = pr.ProductSKU
	INNER JOIN DimProduct p ON pr.ProductSKU = p.ProductSKU
	INNER JOIN DimRawMaterial rm ON pr.RawMaterialID = rm.RawMaterialID
WHERE p.RowIsCurrent = 1 AND rm.RowIsCurrent = 1 AND s.OrderStatus <> 'Complete'
ORDER BY ver;
-------------------------------------------------------------------------------------------------------------------------------

truncate table FactSales;
truncate table FactProduction;

SELECT * FROM FactProduction;
SELECT * FROM FactSales;
SELECT * FROM StagingCataskevasticha.dbo.Sales;




