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

INSERT INTO DimProduct (ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays)
SELECT ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays
FROM StagingCataskevasticha.dbo.Products;

SELECT * FROM DimProduct;


-- Create Constraints
USE CataskevastichaDW;

--ALTER TABLE DimCustomer
--ADD CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerKey);

ALTER TABLE FactSales ADD FOREIGN KEY (CustomerKey)
REFERENCES DimCustomer(CustomerKey);

ALTER TABLE FactSales ADD FOREIGN KEY (EmployeeKey)
REFERENCES DimEmployee(EmployeeKey);

--ALTER TABLE FactSales
--ALTER COLUMN ProductKey INT;

ALTER TABLE FactSales ADD FOREIGN KEY (ProductKey)
REFERENCES DimProduct (ProductKey);

ALTER TABLE FactSales ADD FOREIGN KEY (RequestDateKey)
REFERENCEs DimDate(DateKey);

ALTER TABLE FactSales ADD FOREIGN KEY (StatusDateKey)
REFERENCEs DimDate(DateKey);

--ALTER TABLE FactSales ADD FOREIGN KEY (DeliveryDateKey)
--REFERENCEs DimDate(DateKey);

--ALTER TABLE FactSales ADD FOREIGN KEY (CompletedDateKey)
--REFERENCEs DimDate(DateKey);

--ALTER TABLE FactSales ADD FOREIGN KEY (CancelDateKey)
--REFERENCEs DimDate(DateKey);

--ALTER TABLE FactProduction
--ALTER COLUMN ProductKey INT;

ALTER TABLE FactProduction ADD FOREIGN KEY (ProductKey)
REFERENCES DimProduct (ProductKey);

ALTER TABLE FactProduction ADD FOREIGN KEY (RawMaterialKey)
REFERENCES DimRawMaterial (RawMaterialKey);

ALTER TABLE FactProduction ADD FOREIGN KEY (InProcessDateKey)
REFERENCES DimDate (DateKey);

ALTER TABLE FactProduction ADD FOREIGN KEY (CompletedDateKey)
REFERENCES DimDate (DateKey);


SELECT * FROM FactSales;
SELECT * FROM StagingCataskevasticha.dbo.Sales;

INSERT INTO 
	FactSales(EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner)
SELECT 
	e.EmployeeKey, c.CustomerKey, s.OrderID, p.ProductKey, 
	CAST(FORMAT(RequestDate,'yyyyMMdd') AS INT) RequestDateKey, 
	CAST(FORMAT(StatusDate,'yyyyMMdd') AS INT) StatusDateKey,
	/*CASE 
		WHEN OrderStatus = 'In Delivery' THEN CAST(FORMAT(StatusDate,'yyyyMMdd') AS INT) ELSE '99991231'
	END AS DeliveryDateKey, 
	CASE 
		WHEN OrderStatus = 'Complete' THEN CAST(FORMAT(StatusDate,'yyyyMMdd') AS INT) ELSE '99991231'
	END AS CompletedDateKey,
	CASE 
		WHEN OrderStatus = 'Cancelled' THEN CAST(FORMAT(StatusDate,'yyyyMMdd') AS INT) ELSE '99991231'
	END AS CancelDateKey,*/
	s.OrderStatus, s.Quantity, s.LogisticsPartner
FROM StagingCataskevasticha.dbo.Sales s
	INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	INNER JOIN DimCustomer c ON s.CustomerID = c.CustomerID
	INNER JOIN DimEmployee e ON s.ProductionEmployeeID = e.EmployeeID
WHERE p.RowIsCurrent = 1 AND c.RowIsCurrent = 1 AND e.RowIsCurrent = 1;

SELECT * FROM FactSales;

SELECT * FROM FactProduction;
SELECT * FROM StagingCataskevasticha.dbo.Sales;



WITH Result (ProductSKU, RawMaterialKey, Quantity, RowIsCurrent) AS
(
    SELECT 
	     rwp.ProductSKU, rw.RawMaterialKey, rwp.Quantity, rw.RowIsCurrent
    FROM StagingCataskevasticha.dbo.Production rwp
	    INNER JOIN DimRawMaterial rw ON rwp.RawMaterialID = rw.RawMaterialID
)
INSERT INTO 
	FactProduction(ProductKey, RawMaterialKey, OrderID, ProductStatus, InProcessDateKey, CompletedDateKey, Quantity)  --Quantity of materials
SELECT 
	p.ProductKey, re.RawMaterialKey, s.OrderID, s.ProductStatus,
	CAST(FORMAT(RequestDate,'yyyyMMdd') AS INT) InProcessDateKey, 
	CAST(FORMAT(ProductDoneDate,'yyyyMMdd') AS INT) CompletedDateKey,
	re.Quantity
FROM StagingCataskevasticha.dbo.Sales s
	INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	INNER JOIN Result re ON s.ProductSKU = re.ProductSKU 
WHERE p.RowIsCurrent = 1 AND re.RowIsCurrent = 1;

SELECT * FROM FactProduction;
SELECT * FROM FactSales;