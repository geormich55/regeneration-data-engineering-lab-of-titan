-- Create Cataschevastica Database
CREATE DATABASE Cataskevasticha;
GO

USE Cataskevasticha;
GO

-- Products Table
CREATE TABLE Products (
    ProductSKU VARCHAR(50) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Length DECIMAL(10, 2) NOT NULL,
    Width DECIMAL(10, 2) NOT NULL,
    Thickness DECIMAL(10, 2) NOT NULL,
    Weight DECIMAL(10, 2) NOT NULL,
    SurfaceFinish NVARCHAR(255),
    Color VARCHAR(100),
    ComplianceStandards VARCHAR(100) NOT NULL,
    CostPerUnit DECIMAL(10, 2) NOT NULL,
    ConstructionTimeInDays INT NOT NULL
);

-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(255)
);

-- RawMaterials Table
CREATE TABLE RawMaterials (
    RawMaterialID INT IDENTITY(1,1) PRIMARY KEY,
    RawMaterialName VARCHAR(100),
    SupplierID INT,
    CONSTRAINT FK_SupplierID FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    CustomerAddress NVARCHAR(255)
);

-- ProductionTeam Table
CREATE TABLE ProductionTeam (
    ProductionEmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    RequestDate DATETIME,
    OrderStatus VARCHAR(100) NOT NULL DEFAULT 'In Process' CHECK (OrderStatus IN ('In Process', 'In Delivery', 'Complete', 'Cancelled')),
    ProductionEmployeeID INT,
    LogisticsPartner VARCHAR(100),
    CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_ProductionEmployeeID FOREIGN KEY (ProductionEmployeeID) REFERENCES ProductionTeam(ProductionEmployeeID)
);


-- OrderStatusHistory Table
CREATE TABLE OrderStatusHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderStatus VARCHAR(100) NOT NULL CHECK (OrderStatus IN ('In Process', 'In Delivery', 'Complete', 'Cancelled')),
    StatusDate DATETIME,
    OrderID INT,
    CONSTRAINT FK_OrderID_StatusHistory FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- OrderProductList Table
CREATE TABLE OrdersList (
    OrderID INT,
    ProductSKU VARCHAR(50),
    ProductStatus VARCHAR(100) DEFAULT 'In Production',
	Quantity INT NOT NULL,
	PRIMARY KEY(OrderID, ProductSKU),
    CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT FK_ProductSKU FOREIGN KEY (ProductSKU) REFERENCES Products(ProductSKU)
);

CREATE TABLE Needs (
  Quantity INT NOT NULL,
  RawMaterialID INT NOT NULL,
  ProductSKU VARCHAR(50) NOT NULL,
  PRIMARY KEY (RawMaterialID, ProductSKU),
  FOREIGN KEY (RawMaterialID) REFERENCES RawMaterials(RawMaterialID),
  FOREIGN KEY (ProductSKU) REFERENCES Products(ProductSKU)
);