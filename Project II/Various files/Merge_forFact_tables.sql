USE CataskevastichaDW ;

--Merge for FactSales SCD Type 1 or incremental loading if only NOT MATCHED BY TARGET clause remains-METHOD 1--

SELECT * FROM StagingCataskevasticha.dbo.Sales;
SELECT * FROM FactSales;
SELECT * FROM DimProduct;



MERGE FactSales AS [target]
USING (
    SELECT 
	    e.EmployeeKey,
		c.CustomerKey,
        S.OrderID,
        p.ProductKey,
        S.RequestDate, 
	    S.StatusDate,
        S.OrderStatus,
        S.Quantity,
        S.LogisticsPartner
    FROM StagingCataskevasticha.dbo.Sales s
	    INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	    INNER JOIN DimCustomer c ON s.CustomerID = c.CustomerID
	    INNER JOIN DimEmployee e ON s.ProductionEmployeeID = e.EmployeeID
    WHERE p.RowIsCurrent = 1 AND c.RowIsCurrent = 1 AND e.RowIsCurrent = 1
) AS [source]
ON target.OrderID = source.OrderID AND target.ProductKey = source.ProductKey AND target.OrderStatus=source.OrderStatus --it's like forming a composite key--
    WHEN MATCHED AND                                                                                      --auto mporei na ginei delete an den xreiazetai--
        (CAST(FORMAT(source.RequestDate, 'yyyyMMdd') AS INT) <> target.RequestDateKey 
         OR CAST(FORMAT(source.StatusDate, 'yyyyMMdd') AS INT) <> target.StatusDateKey  
         OR source.Quantity <> target.Quantity 
         OR source.LogisticsPartner <> target.LogisticsPartner
		 OR source.CustomerKey <> target.CustomerKey
		 OR source.EmployeeKey <> target.EmployeeKey)
		 --OR source.ProductKey <> target.ProductKey
		 --OR source.OrderStatus <> target.OrderStatus)
      THEN UPDATE SET 
        target.RequestDateKey = CAST(FORMAT(source.RequestDate, 'yyyyMMdd') AS INT),
        target.StatusDateKey = CAST(FORMAT(source.StatusDate, 'yyyyMMdd') AS INT),
        target.Quantity = source.Quantity,
		target.CustomerKey = source.CustomerKey,
		target.EmployeeKey = source.EmployeeKey,
		target.LogisticsPartner = source.LogisticsPartner
		--target.ProductKey = source.ProductKey,
		--target.OrderStatus = source.OrderStatus
    WHEN NOT MATCHED BY TARGET 
      THEN INSERT (EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner)
        VALUES (source.EmployeeKey, source.CustomerKey, source.OrderID, source.ProductKey, 
                CAST(FORMAT(source.RequestDate, 'yyyyMMdd') AS INT), 
                CAST(FORMAT(source.StatusDate, 'yyyyMMdd') AS INT), 
                source.OrderStatus, source.Quantity, source.LogisticsPartner);
    --WHEN NOT MATCHED BY SOURCE     --auto mporei na ginei delete an den xreiazetai
      --THEN DELETE;


INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BRK123', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-20 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 7, CONVERT(DATE, '2025-03-15 00:00:00.000')));


--Merge for FactProduction SCD Type 1-Method 1-Version 1--diagrafontai ta duplicates--

SELECT * FROM StagingCataskevasticha.dbo.Production;
SELECT * FROM StagingCataskevasticha.dbo.Sales;
SELECT * FROM FactProduction;
SELECT * FROM FactSales;
SELECT * FROM DimProduct;

DELETE FROM FactProduction WHERE ID<90



-- Step 1: Add a new column
ALTER TABLE FactProduction
ADD RowNumber INT;

-- Optionally, add a surrogate key if no suitable column exists for ordering
ALTER TABLE FactProduction
--DROP COLUMN ID;
ADD ID INT IDENTITY(1,1);

-- Step 2: Update the column
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY ProductKey, OrderID, ProductStatus ORDER BY ID) AS row_num
    FROM 
        FactProduction
)
UPDATE CTE SET
RowNumber = row_num;

SELECT * FROM FactProduction;

-- Step 3: Delete duplicates
DELETE FROM FactProduction
WHERE RowNumber > 1;

-- Optionally, remove the RowNumber and surrogate key columns if no longer needed
ALTER TABLE FactProduction
DROP COLUMN RowNumber, ID;

WITH Result (ProductSKU, RawMaterialKey, Quantity, RowIsCurrent) AS
    (
        SELECT 
	         rwp.ProductSKU, rw.RawMaterialKey, rwp.Quantity, rw.RowIsCurrent
        FROM StagingCataskevasticha.dbo.Production rwp
	        INNER JOIN DimRawMaterial rw ON rwp.RawMaterialID = rw.RawMaterialID
    )
MERGE FactProduction AS [target]
USING (
    SELECT 
	    p.ProductKey, re.RawMaterialKey, s.OrderID, s.ProductStatus,
	    CAST(FORMAT(RequestDate,'yyyyMMdd') AS INT) InProcessDateKey, 
	    CAST(FORMAT(ProductDoneDate,'yyyyMMdd') AS INT) CompletedDateKey,
	    re.Quantity
    FROM StagingCataskevasticha.dbo.Sales s
	    INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	    INNER JOIN Result re ON s.ProductSKU = re.ProductSKU 
    WHERE p.RowIsCurrent = 1 AND re.RowIsCurrent = 1
) AS [source]
ON target.OrderID = source.OrderID AND target.ProductKey = source.ProductKey AND target.ProductStatus=source.ProductStatus --it's like forming a composite key--
    WHEN MATCHED AND                                                                                      --auto mporei na ginei delete an den xreiazetai--
         (source.RawMaterialKey <> target.RawMaterialKey
         OR source.InProcessDateKey <> target.InProcessDateKey
		 OR source.CompletedDateKey <> target.CompletedDateKey
         OR source.Quantity <> target.Quantity)
		 --OR source.ProductKey <> target.ProductKey
		 --OR source.ProductStatus <> target.ProductStatus)
      THEN UPDATE SET 
        target.RawMaterialKey = source.RawMaterialKey,
        target.InProcessDateKey = source.InProcessDateKey,
		target.CompletedDateKey = source.CompletedDateKey,         --prepei na mpei to statusdatekey an to table factproduction exei mono statusdatekey
        target.Quantity = source.Quantity
		--target.ProductKey = source.ProductKey,
		--target.ProductStatus = source.ProductStatus
    WHEN NOT MATCHED BY TARGET 
      THEN INSERT (ProductKey, RawMaterialKey, OrderID, ProductStatus, InProcessDateKey, CompletedDateKey, Quantity)
        VALUES (source.ProductKey, source.RawMaterialKey, source.OrderID, source.ProductStatus, 
                source.InprocessDateKey, 
                source.CompletedDateKey, 
                source.Quantity);
    --WHEN NOT MATCHED BY SOURCE --auto mporei na ginei delete an den xreiazetai--
      --THEN DELETE;


INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BRK123', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-20 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 7, CONVERT(DATE, '2025-03-15 00:00:00.000')));


--Merge for FactProduction SCD Type 1-Method 1-Version 2----den diagrafontai ta duplicates..pairnei to factproduction sthlh orderstatus gia epilogh monadikhs row gia rowversion san composite key kai epeita diagrafetai--

SELECT * FROM StagingCataskevasticha.dbo.Production;
SELECT * FROM StagingCataskevasticha.dbo.Sales;
SELECT * FROM FactProduction;
SELECT * FROM FactSales;
SELECT * FROM DimProduct;


ALTER TABLE FactProduction
ADD OrderStatus VARCHAR(100);

ALTER TABLE FactProduction
ADD ID INT IDENTITY(1,1);

SELECT * FROM FactProduction;

SELECT OrderStatus
INTO tableb
FROM StagingCataskevasticha.dbo.Sales;

SELECT * FROM tableb;

ALTER TABLE tableb
ADD ID INT IDENTITY(1,1);

UPDATE FactProduction
SET FactProduction.OrderStatus = tableb.OrderStatus
FROM FactProduction
JOIN tableb ON FactProduction.ID = tableb.ID

DROP TABLE tableb;

ALTER TABLE FactProduction
DROP COLUMN ID;

WITH Result (ProductSKU, RawMaterialKey, Quantity, RowIsCurrent) AS
    (
        SELECT 
	         rwp.ProductSKU, rw.RawMaterialKey, rwp.Quantity, rw.RowIsCurrent
        FROM StagingCataskevasticha.dbo.Production rwp
	        INNER JOIN DimRawMaterial rw ON rwp.RawMaterialID = rw.RawMaterialID
    )
MERGE FactProduction AS [target]
USING (
    SELECT 
	    p.ProductKey, re.RawMaterialKey, s.OrderID, s.ProductStatus,
	    CAST(FORMAT(RequestDate,'yyyyMMdd') AS INT) InProcessDateKey, 
	    CAST(FORMAT(ProductDoneDate,'yyyyMMdd') AS INT) CompletedDateKey,
	    re.Quantity, s.OrderStatus
    FROM StagingCataskevasticha.dbo.Sales s
	    INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	    INNER JOIN Result re ON s.ProductSKU = re.ProductSKU 
    WHERE p.RowIsCurrent = 1 AND re.RowIsCurrent = 1
) AS [source]
ON target.OrderID = source.OrderID AND target.ProductKey = source.ProductKey AND target.OrderStatus = source.OrderStatus --it's like forming a composite key--
    WHEN MATCHED AND                                                                                           --auto mporei na ginei delete an den xreiazetai--
         (source.RawMaterialKey <> target.RawMaterialKey
         OR source.InProcessDateKey <> target.InProcessDateKey                
		 OR source.CompletedDateKey <> target.CompletedDateKey                     --prepei na mpei to statusdatekey an to table factproduction exei mono statusdatekey
         OR source.Quantity <> target.Quantity) 
		 --OR source.ProductKey <> target.ProductKey
		 --OR source.OrderStatus <> target.OrderStatus)
      THEN UPDATE SET 
        target.RawMaterialKey = source.RawMaterialKey,
        target.InProcessDateKey = source.InProcessDateKey,
		target.CompletedDateKey = source.CompletedDateKey,              
        target.Quantity = source.Quantity
		--target.ProductKey = source.ProductKey,
		--target.OrderStatus = source.OrderStatus
    WHEN NOT MATCHED BY TARGET 
      THEN INSERT (ProductKey, RawMaterialKey, OrderID, ProductStatus, InProcessDateKey, CompletedDateKey, Quantity, OrderStatus)
        VALUES (source.ProductKey, source.RawMaterialKey, source.OrderID, source.OrderStatus, 
                source.InprocessDateKey, 
                source.CompletedDateKey, 
                source.Quantity,
				source.OrderStatus);
    --WHEN NOT MATCHED BY SOURCE     --auto mporei na ginei delete an den xreiazetai
      --THEN DELETE;


INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BRK123', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-20 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 7, CONVERT(DATE, '2025-03-15 00:00:00.000')));


ALTER TABLE FactProduction
DROP COLUMN OrderStatus;

SELECT * FROM FactProduction;

