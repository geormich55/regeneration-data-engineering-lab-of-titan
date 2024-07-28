---------------------------------------------------------------------------------
-- Clustered index to order the rows based on the row version
CREATE CLUSTERED INDEX IX_FactSales_Version 
ON FactSales (Row_version ASC);

-- Insert new or updated records into FactSales
INSERT INTO 
	FactSales(EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner, TotalPrice, Row_version)
SELECT
	e.EmployeeKey, c.CustomerKey, s.OrderID, p.ProductKey, 
	CAST(FORMAT(RequestDate,'yyyyMMdd') AS INT) RequestDateKey, 
	CAST(FORMAT(StatusDate,'yyyyMMdd') AS INT) StatusDateKey,
	s.OrderStatus, s.Quantity, s.LogisticsPartner, (Quantity * p.CostPerUnit), CAST(s.[version] AS BIGINT) as ver
FROM StagingCataskevasticha.dbo.Sales s
	INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	INNER JOIN DimCustomer c ON s.CustomerID = c.CustomerID
	INNER JOIN DimEmployee e ON s.ProductionEmployeeID = e.EmployeeID 
WHERE s.[version] > (SELECT COALESCE(MAX(Row_version),-1) FROM FactSales) -- Colaesce is to catch NULL rowversion if the warehouse is empty
	AND p.RowIsCurrent = 1 AND c.RowIsCurrent = 1 AND e.RowIsCurrent = 1;
-- ORDER BY ver;


--DROP INDEX IX_FactSales_Version ON FactSales;


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

CREATE CLUSTERED INDEX IX_FactProduction_Version 
ON FactProduction (Row_version ASC);

INSERT INTO 
	FactProduction(ProductKey, RawMaterialKey, OrderID, ProductStatus, StatusDateKey,Quantity, Row_version)  --Quantity of materials
SELECT 
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
WHERE s.[version] > (SELECT COALESCE(MAX(Row_version),-1) FROM FactProduction)
	AND p.RowIsCurrent = 1 AND rm.RowIsCurrent = 1 AND s.OrderStatus <> 'Complete';
--ORDER BY ver;

--DROP INDEX IX_FactProduction_Version ON FactSales;