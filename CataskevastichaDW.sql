CREATE DATABASE CataskevastichaDW;
GO 
USE CataskevastichaDW;
GO

-- Create DimEmployee

CREATE TABLE DimEmployee(
	EmployeeKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	EmployeeID INT NOT NULL, -- Natural Key / Business Key
	EmployeeName VARCHAR(120) NOT NULL,
	RowIsCurrent BIT DEFAULT 1 NOT NULL,
	RowStartDate DATETIME2 DEFAULT SYSDATETIME(),
	RowEndDate DATETIME2 DEFAULT('9999-12-31'),
	RowChangeReason VARCHAR(200)
);

SELECT * FROM DimEmployee;

-- Create DimCustomer

SELECT * FROM StagingCataskevasticha.dbo.Customers;

CREATE TABLE DimCustomer(
	CustomerKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	CustomerID VARCHAR(20) NOT NULL, -- Natural/Business Key
	CustomerName VARCHAR(80) NOT NULL,
	Email VARCHAR(80) NOT NULL,
	Phone VARCHAR(40) NOT NULL,
	CustomerAddress VARCHAR(25) NOT NULL,
	RowIsCurrent BIT DEFAULT 1 NOT NULL,
	RowStartDate DATETIME2 DEFAULT SYSDATETIME(),
	RowEndDate DATETIME2 DEFAULT('9999-12-31'),
	RowChangeReason VARCHAR(200)
);

SELECT * FROM DimCustomer;

-- Create DimRawMaterial

CREATE TABLE DimRawMaterial(
	RawMaterialKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	RawMaterialID INT NOT NULL, -- Natural/Business Key
	RawMaterialName VARCHAR(80) NOT NULL,
	SupplierID VARCHAR(20) NOT NULL,
	SupplierName VARCHAR(40) NOT NULL,
	RowIsCurrent BIT DEFAULT 1 NOT NULL,
	RowStartDate DATETIME2 DEFAULT SYSDATETIME(),
	RowEndDate DATETIME2 DEFAULT('9999-12-31'),
	RowChangeReason VARCHAR(200)
);

SELECT * FROM DimRawMaterial;


-- Create DimProduct

CREATE TABLE DimProduct(
	ProductKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	ProductSKU VARCHAR(50) NOT NULL, -- Natural/Business Key
	ProductName VARCHAR(100) NOT NULL,
	CostPerUnit DECIMAL(10, 2) NOT NULL,
	ConstructionTimeInDays INT NOT NULL,
	Color VARCHAR(50),
	RowIsCurrent BIT DEFAULT 1 NOT NULL,
	RowStartDate DATETIME2 DEFAULT SYSDATETIME(),
	RowEndDate DATETIME2 DEFAULT('9999-12-31'),
	RowChangeReason VARCHAR(200)
);

SELECT * FROM DimProduct;

-------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-- Create Fact Table Production
CREATE TABLE FactProduction(
	ProductKey INT NOT NULL, 
	RawMaterialKey INT NOT NULL,
	OrderID INT NOT NULL,
	ProductStatus VARCHAR(100) NOT NULL,
	StatusDateKey INT NOT NULL,
	Quantity SMALLINT NOT NULL, -- Quantity of material
	Row_version BIGINT
);

SELECT * FROM FactProduction;

-- Create Fact Table Sales
CREATE TABLE FactSales(
	EmployeeKey INT NOT NULL, 
	CustomerKey INT NOT NULL,
	OrderID INT NOT NULL,
	ProductKey INT NOT NULL,
	RequestDateKey INT NOT NULL,
	StatusDateKey INT,
	OrderStatus VARCHAR(100) NOT NULL,
	Quantity SMALLINT NOT NULL, -- Quantity of products
	LogisticsPartner VARCHAR(100) NOT NULL,
	TotalPrice DECIMAL(10, 2) NOT NULL,
	Row_version BIGINT
);

SELECT * FROM FactSales;





