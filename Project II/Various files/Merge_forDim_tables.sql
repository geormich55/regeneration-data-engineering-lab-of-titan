USE CataskevastichaDW ;

--MERGE FOR DimEmployee SCD Type 2--

ALTER TABLE FactSales
NOCHECK CONSTRAINT FK__FactSales__Emplo__4BAC3F29
GO

SELECT * FROM DimEmployee;
SELECT * FROM StagingCataskevasticha.dbo.Employees;

INSERT INTO DimEmployee (EmployeeID, EmployeeName, RowIsCurrent, RowStartDate, RowEndDate)
SELECT ProductionEmployeeID, EmployeeName, 1, SYSDATETIME(), '9999-12-31'
FROM(
    MERGE DimEmployee AS [target]
    USING StagingCataskevasticha.dbo.Employees AS [source]
    ON target.EmployeeID = source.ProductionEmployeeID 
        WHEN MATCHED AND (source.EmployeeName <> Target.EmployeeName)
            THEN UPDATE SET target.RowIsCurrent = 0, Target.RowEndDate = SYSDATETIME()
        WHEN NOT MATCHED BY TARGET 
            THEN INSERT (EmployeeID, EmployeeName, RowStartDate, RowEndDate)
                VALUES (source.ProductionEmployeeID, source.EmployeeName, SYSDATETIME(), '9999-12-31')
        WHEN NOT MATCHED BY Source 
            THEN UPDATE SET target.RowEndDate = SYSDATETIME()
    OUTPUT Source.ProductionEmployeeID, Source.EmployeeName, $Action AS ActionName
) AS [Merge]
WHERE ActionName = 'UPDATE'
AND ProductionEmployeeID IS NOT NULL;

ALTER TABLE FactSales
CHECK CONSTRAINT FK__FactSales__Emplo__4BAC3F29
GO

--MERGE FOR Dimcustomer SCD Type 2--

ALTER TABLE FactSales
NOCHECK CONSTRAINT FK__FactSales__Custo__4AB81AF0
GO

SELECT * FROM DimCustomer;
SELECT * FROM StagingCataskevasticha.dbo.Customers;

INSERT INTO DimCustomer (CustomerID, CustomerName, Email, Phone, CustomerAddress, RowIsCurrent, RowStartDate, RowEndDate)
SELECT CustomerID, CustomerName, Email, Phone, CustomerAddress, 1, SYSDATETIME(), '9999-12-31'
FROM(
    MERGE DimCustomer AS [target]
    USING StagingCataskevasticha.dbo.Customers AS [source]
    ON target.CustomerID = source.CustomerID 
        WHEN MATCHED AND (source.CustomerName <> Target.CustomerName OR source.Email <> Target.Email OR source.Phone <> Target.Phone OR source.CustomerAddress <> Target.CustomerAddress)
            THEN UPDATE SET target.RowIsCurrent = 0, Target.RowEndDate = SYSDATETIME()
        WHEN NOT MATCHED BY TARGET 
            THEN INSERT (CustomerID, CustomerName, Email, Phone, CustomerAddress, RowStartDate, RowEndDate)
                VALUES (source.CustomerID, source.CustomerName, source.Email, source.Phone, source.CustomerAddress, SYSDATETIME(), '9999-12-31')
        WHEN NOT MATCHED BY Source 
            THEN UPDATE SET target.RowEndDate = SYSDATETIME()
    OUTPUT Source.CustomerID, Source.CustomerName, Source.Email, Source.Phone, Source.CustomerAddress, $Action AS ActionName
) AS [Merge]
WHERE ActionName = 'UPDATE'
AND CustomerID IS NOT NULL;

ALTER TABLE FactSales
CHECK CONSTRAINT FK__FactSales__Custo__4AB81AF0
GO

--MERGE for DimRawMaterial for SCD Type 2--

ALTER TABLE FactProduction
NOCHECK CONSTRAINT FK__FactProdu__RawMa__59063A47
GO

SELECT * FROM DimRawMaterial;
SELECT * FROM StagingCataskevasticha.dbo.RawMaterials;

INSERT INTO DimRawMaterial (RawMaterialID, RawMaterialName, SupplierID, SupplierName, RowIsCurrent, RowStartDate, RowEndDate)
SELECT RawMaterialID, RawMaterialName, SupplierID, SupplierName, 1, SYSDATETIME(), '9999-12-31'
FROM(
    MERGE DimRawMaterial AS [target]
    USING StagingCataskevasticha.dbo.RawMaterials AS [source]
    ON target.RawMaterialID = source.RawMaterialID 
        WHEN MATCHED AND (source.RawMaterialName <> Target.RawMaterialName OR source.SupplierID <> Target.SupplierID OR source.SupplierName <> Target.SupplierName)
            THEN UPDATE SET target.RowIsCurrent = 0, Target.RowEndDate = SYSDATETIME()
        WHEN NOT MATCHED BY TARGET 
            THEN INSERT (RawMaterialID, RawMaterialName, SupplierID, SupplierName, RowStartDate, RowEndDate)
                VALUES (source.RawMaterialID, source.RawMaterialName, source.SupplierID, source.SupplierName, SYSDATETIME(), '9999-12-31')
        WHEN NOT MATCHED BY Source 
            THEN UPDATE SET target.RowEndDate = SYSDATETIME()
    OUTPUT source.RawMaterialID, source.RawMaterialName, source.SupplierID, source.SupplierName, $Action AS ActionName
) AS [Merge]
WHERE ActionName = 'UPDATE'
AND RawMaterialID IS NOT NULL;

ALTER TABLE FactProduction
CHECK CONSTRAINT FK__FactProdu__RawMa__59063A47
GO


--MERGE for DimProduct SCD Type 2--

ALTER TABLE FactProduction
NOCHECK CONSTRAINT FK__FactProdu__Produ__5812160E
GO

ALTER TABLE FactSales
NOCHECK CONSTRAINT FK__FactSales__Produ__4CA06362
GO

SELECT * FROM DimProduct;
SELECT * FROM StagingCataskevasticha.dbo.Products;

INSERT INTO DimProduct (ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays, RowIsCurrent, RowStartDate, RowEndDate)
SELECT ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays, 1, SYSDATETIME(), '9999-12-31'
FROM(
    MERGE DimProduct AS [target]
    USING StagingCataskevasticha.dbo.Products AS [source]
    ON target.ProductSKU = source.ProductSKU 
        WHEN MATCHED AND (source.ProductName <> Target.ProductName OR source.CostPerUnit <> Target.CostPerUnit OR source.ConstructionTimeInDays <> Target.ConstructionTimeInDays)
            THEN UPDATE SET target.RowIsCurrent = 0, Target.RowEndDate = SYSDATETIME()
        WHEN NOT MATCHED BY TARGET 
            THEN INSERT (ProductSKU, ProductName, CostPerUnit, ConstructionTimeInDays, RowStartDate, RowEndDate)
                VALUES (source.ProductSKU, source.ProductName, source.CostPerUnit, source.ConstructionTimeInDays, SYSDATETIME(), '9999-12-31')
        WHEN NOT MATCHED BY Source 
            THEN UPDATE SET target.RowEndDate = SYSDATETIME()
    OUTPUT source.ProductSKU, source.ProductName, source.CostPerUnit, source.ConstructionTimeInDays, $Action AS ActionName
) AS [Merge]
WHERE ActionName = 'UPDATE'
AND ProductSKU IS NOT NULL;

ALTER TABLE FactProduction
CHECK CONSTRAINT FK__FactProdu__Produ__5812160E
GO

ALTER TABLE FactSales
CHECK CONSTRAINT FK__FactSales__Produ__4CA06362
GO