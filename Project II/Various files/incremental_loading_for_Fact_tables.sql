USE CataskevastichaDW ;

--Incremental loading with dates for FactSales-METHOD 2--

SELECT * FROM StagingCataskevasticha.dbo.Sales;
SELECT * FROM FactSales;
SELECT * FROM DimProduct;
SELECT * FROM FactProduction;
SELECT * FROM DimRawMaterial;
SELECT * FROM DimEmployee;


ALTER TABLE FactSales
ADD ID INT IDENTITY(1,1);

ALTER TABLE StagingCataskevasticha.dbo.Sales
ADD ID INT IDENTITY(1,1);

ALTER TABLE FactSales
ADD CountStOrd INT;

WITH NumberedRows AS (
    SELECT 
        OrderID,
        ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY OrderID) AS CountStOrd,
        ID -- Replace with the actual primary key of the FactSales table
    FROM FactSales
)
UPDATE fs
SET fs.CountStOrd = nr.CountStOrd
FROM FactSales fs
JOIN NumberedRows nr ON fs.ID = nr.ID;



INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BRK123', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-15 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 7, CONVERT(DATE, '2025-03-15 00:00:00.000')));

INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BLK456', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-15 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 5, CONVERT(DATE, '2025-03-15 00:00:00.000')));


DELETE FROM StagingCataskevasticha.dbo.Sales WHERE ID>90;
DELETE FROM FactSales Where ID>90;

--Eisodoi timwn sthn FactSales apo to Staging gia prosthhkes..incremental loading me kapoia dates..se auto to version eisagontai mono oi times apo thn factsales pou throun ta krithria pou prepei peran tou date

WITH Result AS
(
    SELECT 
        e.EmployeeKey,
        c.CustomerKey,
        s.OrderID,
        p.ProductKey,
        LAG(p.ProductKey) OVER (PARTITION BY s.OrderID ORDER BY s.StatusDate, p.ProductKey) AS PreviousProductKey,
        CAST(FORMAT(RequestDate, 'yyyyMMdd') AS INT) AS RequestDateKey,
        CAST(FORMAT(StatusDate, 'yyyyMMdd') AS INT) AS StatusDateKey,
        s.OrderStatus,
        s.Quantity,
        s.LogisticsPartner,
        COUNT(*) OVER (PARTITION BY OrderID, CAST(FORMAT(StatusDate, 'yyyyMMdd') AS INT)) AS StatusDateKeyCount,
        COUNT(*) OVER (PARTITION BY OrderID) AS OrderIDCount,
        ROW_NUMBER() OVER (PARTITION BY s.OrderID ORDER BY s.StatusDate, p.ProductKey) AS CountStOrd
    FROM StagingCataskevasticha.dbo.Sales s
    INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
    INNER JOIN DimCustomer c ON s.CustomerID = c.CustomerID
    INNER JOIN DimEmployee e ON s.ProductionEmployeeID = e.EmployeeID
    WHERE p.RowIsCurrent = 1 AND c.RowIsCurrent = 1 AND e.RowIsCurrent = 1
)
INSERT INTO FactSales (EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner, CountStOrd)
SELECT 
    EmployeeKey, 
    CustomerKey, 
    OrderID, 
    ProductKey, 
    RequestDateKey, 
    StatusDateKey, 
    OrderStatus, 
    Quantity, 
    LogisticsPartner, 
    CountStOrd
FROM Result re
WHERE 
    (RequestDateKey = (SELECT MAX(RequestDateKey) FROM FactSales) 
     AND StatusDateKeyCount <= 2 
     AND OrderIDCount < StatusDateKeyCount * 3 
     AND OrderStatus = 'In Process' 
     AND ProductKey <> PreviousProductKey 
     AND CountStOrd > (SELECT MAX(CountStOrd) FROM FactSales WHERE RequestDateKey = (SELECT MAX(RequestDateKey) FROM FactSales)))
 OR 
    (RequestDateKey = (SELECT MAX(RequestDateKey) FROM FactSales) 
     AND StatusDateKeyCount <= 2                                      --StatusDateKeyCount <= 2 ..to 2 einai o arithmos twn products ana paraggelia..sto paradeigma einai panta 2..
     AND OrderIDCount <= StatusDateKeyCount * 3 
     AND (OrderStatus = 'In Delivery' OR OrderStatus = 'Complete') 
     AND ProductKey = PreviousProductKey 
     AND CountStOrd > (SELECT MAX(CountStOrd) FROM FactSales WHERE RequestDateKey = (SELECT MAX(RequestDateKey) FROM FactSales)))
 OR 
    (RequestDateKey > (SELECT MAX(RequestDateKey) FROM FactSales) 
     AND OrderStatus = 'In Process'
	 AND CountStOrd <= 2);   --auto to line mporei na paraleifthei an epitrepetai na ginoun insert kai panw apo duo rows me OrderStatus = 'In Process'
 /*OR 
    (RequestDateKey = (SELECT MAX(RequestDateKey) FROM FactSales) 
     AND StatusDateKeyCount <= 2 
     AND OrderIDCount <= StatusDateKeyCount * 2                           --auto prostithetai se periptwsh pou uparxoun kai 2 order states In Process kai Cancelled, me 2 products einai 4 states, In Process, In Process, Cancelled, Cancelled
     AND OrderStatus = 'Cancelled'
     AND ProductKey = PreviousProductKey 
     AND CountStOrd > (SELECT MAX(CountStOrd) FROM FactSales WHERE RequestDateKey = (SELECT MAX(RequestDateKey) FROM FactSales)));*/


ALTER TABLE FactSales
DROP COLUMN ID;

ALTER TABLE FactSales
DROP COLUMN CountStOrd;

ALTER TABLE StagingCataskevasticha.dbo.Sales
DROP COLUMN ID;

SELECT * FROM FactSales;



--Incremental loading with dates for FactProduction-METHOD 2--

SELECT *FROM FactProduction;
SELECT *FROM StagingCataskevasticha.dbo.Sales;
SELECT * FROM FactSales;
SELECT * FROM StagingCataskevasticha.dbo.Production;
SELECT *FROM DimRawMaterial;
SELECT *FROM DimProduct;

ALTER TABLE FactProduction
ADD ProductDoneDateKeyCou INT;

ALTER TABLE FactProduction
ADD OrderIDCou INT;

ALTER TABLE FactProduction
ADD ProductKeyCou INT;

ALTER TABLE FactProduction
ADD CountStOrd INT;

ALTER TABLE StagingCataskevasticha.dbo.Sales
ADD ID INT IDENTITY(1,1);

ALTER TABLE FactProduction
ADD ID INT IDENTITY(1,1);

WITH NumberedRows AS (
    SELECT 
        OrderID,
        ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY OrderID) AS CountStOrd,
        ID -- Replace with the actual primary key of the FactSales table
    FROM FactProduction
)
UPDATE fp
SET fp.CountStOrd = nr.CountStOrd
FROM FactProduction fp
JOIN NumberedRows nr ON fp.ID = nr.ID;


WITH ProductionData AS (
    SELECT 
        rwp.ProductSKU,
        rw.RawMaterialKey,
        rwp.Quantity,
        rw.RowIsCurrent
    FROM StagingCataskevasticha.dbo.Production rwp
    INNER JOIN DimRawMaterial rw ON rwp.RawMaterialID = rw.RawMaterialID
),
Result AS (
    SELECT 
        p.ProductKey,
        pd.RawMaterialKey,
        s.OrderID,
        s.ProductStatus,
        CAST(FORMAT(s.RequestDate, 'yyyyMMdd') AS INT) AS InProcessDateKey, 
        CAST(FORMAT(s.ProductDoneDate, 'yyyyMMdd') AS INT) AS CompletedDateKey,
        pd.Quantity,
		COUNT(*) OVER (PARTITION BY s.OrderID, CAST(FORMAT(s.ProductDoneDate, 'yyyyMMdd') AS INT)) AS ProductDoneDateKeyCou,
        COUNT(*) OVER (PARTITION BY s.OrderID) AS OrderIDCou,
		LAG(p.ProductKey) OVER (PARTITION BY s.OrderID ORDER BY s.StatusDate, p.ProductKey) AS PreviousProductKey,
		COUNT(*) OVER (PARTITION BY p.ProductKey, s.OrderID) AS ProductKeyCou,
        ROW_NUMBER() OVER (PARTITION BY s.OrderID ORDER BY s.StatusDate, p.ProductKey) AS CountStOrd
    FROM StagingCataskevasticha.dbo.Sales s
    INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
    INNER JOIN ProductionData pd ON s.ProductSKU = pd.ProductSKU
    WHERE p.RowIsCurrent = 1 AND pd.RowIsCurrent = 1
)
INSERT INTO FactProduction(ProductKey, RawMaterialKey, OrderID, ProductStatus, InProcessDateKey, CompletedDateKey, Quantity, ProductDoneDateKeyCou, OrderIDCou, ProductKeyCou, CountStOrd)
SELECT 
    r.ProductKey,
	r.RawMaterialKey,
    r.OrderID,
	r.ProductStatus,
    r.InProcessDateKey,
    r.CompletedDateKey,
    r.Quantity,
	r.ProductDoneDateKeyCou,
	r.OrderIDCou,
	r.ProductKeyCou,
	r.CountStOrd
FROM Result r
WHERE (InProcessDateKey = (SELECT MAX(InProcessDateKey) FROM FactProduction) AND ProductStatus='Completed' AND ProductDoneDateKeyCou <= 2 AND OrderIDCou <= ProductDoneDateKeyCou * 2 AND ProductKeyCou<=2 AND CountStOrd > (SELECT MAX(CountStOrd) FROM FactProduction WHERE InProcessDateKey = (SELECT MAX(InProcessDateKey) FROM FactProduction))) --ProductDoneDateKeyCou <= 2 ..to 2 einai o arithmos twn products ana paraggelia..sto paradeigma einai panta 2..
        OR (InProcessDateKey = (SELECT MAX(InProcessDateKey) FROM FactProduction) AND ProductStatus='In Production' AND ProductKey <> PreviousProductKey AND ProductDoneDateKeyCou <= 2 AND OrderIDCou < ProductDoneDateKeyCou * 2 AND ProductKeyCou<=2 AND CountStOrd > (SELECT MAX(CountStOrd) FROM FactProduction WHERE InProcessDateKey = (SELECT MAX(InProcessDateKey) FROM FactProduction)))                                                                                                                               --(OrderIDCount / 3)) --OrderIDCount / 2) an exoun ginei delete ta diplotupa apo ton factproduction
        OR (InProcessDateKey > (SELECT MAX(InProcessDateKey) FROM FactProduction) AND ProductStatus='In Production' AND CountStOrd <= 2);
      --OR (InProcessDateKey > (SELECT MAX(InProcessDateKey) FROM FactProduction) AND ProductStatus='In Production') h xwris CountStOrd <= 2 an epitrepetai na ginoun insert kai panw apo duo rows me Product Status 'In Production'

--WHERE (InProcessDateKey = (SELECT MAX(InProcessDateKey) FROM FactProduction) AND ProductStatus='Completed' AND ProductDoneDateKeyCou <=2)  --to aplo version opou apla mpainoun katallhles times allla xwris ola ta prerequisites                                                                                                             --(OrderIDCount / 3)) --OrderIDCount / 2) an exoun ginei delete ta diplotupa apo ton factproduction
        --OR (InProcessDateKey = (SELECT MAX(InProcessDateKey) FROM FactProduction) AND ProductStatus='In Production' AND ProductDoneDateKeyCou <=2)
		--OR (InProcessDateKey > (SELECT MAX(InProcessDateKey) FROM FactProduction))


INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BRK123', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-15 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 7, CONVERT(DATE, '2025-03-15 00:00:00.000')));

INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BLK456', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-15 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 5, CONVERT(DATE, '2025-03-15 00:00:00.000')));


DELETE FROM StagingCataskevasticha.dbo.Sales WHERE ID>90;
DELETE FROM FactProduction WHERE ID>90; --h 60 an exoun diagrafei diplotupa


ALTER TABLE FactProduction
DROP COLUMN ProductDoneDateKeyCou;

ALTER TABLE FactProduction
DROP COLUMN OrderIDCou;

ALTER TABLE FactProduction
DROP COLUMN ProductKeyCou;

ALTER TABLE FactProduction
DROP COLUMN CountStOrd;

ALTER TABLE FactProduction
DROP COLUMN ID;

ALTER TABLE StagingCataskevasticha.dbo.Sales
DROP COLUMN ID;


--Incremental loading with ROWVERSION for FactSales-METHOD 3--  --otan metatrepontai se bigint ta rowversion den mpainoun me th swsth seira--

SELECT * FROM FactSales;
SELECT * FROM StagingCataskevasticha.dbo.Sales;

ALTER TABLE StagingCataskevasticha.dbo.Sales
ADD RowVersionColumn rowversion;

ALTER TABLE FactSales
ADD	[version] BIGINT;

--SELECT EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner, [version]
--INTO tablec
--FROM FactSales;


--FIRST OPTION FOR UPDATE FACTSALES WITH VERSION--
WITH Result (ProductKey, OrderID, OrderStatus, RowIsCurrent, RowVersionColumn) AS
    (
        SELECT 
	         p.ProductKey, s.OrderID, s.OrderStatus, p.RowIsCurrent, s.RowVersionColumn
        FROM StagingCataskevasticha.dbo.Sales s
	        INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
		WHERE p.RowIsCurrent=1
    )
UPDATE FactSales
SET FactSales.[version] = CAST(re.RowVersionColumn AS BIGINT)
FROM Result re
WHERE FactSales.OrderID = re.OrderID AND FactSales.ProductKey = re.ProductKey AND FactSales.OrderStatus = re.OrderStatus;

--SECOND OPTION FOR UPDATE FACTSALES WITH VERSION--
UPDATE FactSales
SET FactSales.[version] = CAST(s.RowVersionColumn AS BIGINT)
FROM StagingCataskevasticha.dbo.Sales s
WHERE FactSales.OrderID = s.OrderID AND FactSales.OrderStatus = s.OrderStatus AND FactSales.Quantity = s.Quantity;


SELECT * FROM StagingCataskevasticha.dbo.Sales;
SELECT * FROM FactSales;
SELECT * FROM DimProduct;

--Incremental loading ROWVERSION--

WITH Result (EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner, RowVersionColumn) AS
(
    SELECT 
	    e.EmployeeKey,
		c.CustomerKey,
		s.OrderID,
        p.ProductKey, 
        CAST(FORMAT(RequestDate, 'yyyyMMdd') AS INT) RequestDateKey, 
        CAST(FORMAT(StatusDate, 'yyyyMMdd') AS INT) StatusDateKey, 
        s.OrderStatus, 
        s.Quantity, 
        s.LogisticsPartner,
        CAST([RowVersionColumn] AS BIGINT)
    FROM StagingCataskevasticha.dbo.Sales s
        INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
	    INNER JOIN DimCustomer c ON s.CustomerID = c.CustomerID
	    INNER JOIN DimEmployee e ON s.ProductionEmployeeID = e.EmployeeID
    WHERE p.RowIsCurrent = 1 AND c.RowIsCurrent = 1 AND e.RowIsCurrent = 1
),
MaxRowVersion AS (
    SELECT COALESCE(MAX([version]), 0) AS MaxRowVersionColumn
    FROM FactSales
)
INSERT INTO FactSales(EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner, [version])
SELECT EmployeeKey, CustomerKey, OrderID, ProductKey, RequestDateKey, StatusDateKey, OrderStatus, Quantity, LogisticsPartner, RowVersionColumn
FROM Result
WHERE RowVersionColumn > (SELECT MaxRowVersionColumn FROM MaxRowVersion);


INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BRK123', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-20 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 7, CONVERT(DATE, '2025-03-15 00:00:00.000')));

SELECT * FROM FactSales;
SELECT *FROM StagingCataskevasticha.dbo.Sales;

--DELETE FROM StagingCataskevasticha.dbo.Sales WHERE Quantity=1000;
--DELETE FROM FactSales WHERE Quantity=1000;


ALTER TABLE StagingCataskevasticha.dbo.Sales
DROP COLUMN RowVersionColumn;

ALTER TABLE FactSales
DROP COLUMN [version];



--Incremental loading with ROWVERSION for FactProduction-METHOD 3--   --otan metatrepontai se bigint ta rowversion den mpainoun me th swsth seira--

SELECT * FROM StagingCataskevasticha.dbo.Production;
SELECT * FROM FactSales;
SELECT * FROM FactProduction;
SELECT * FROM StagingCataskevasticha.dbo.Sales;
SELECT * FROM DimRawMaterial;

--sql commands gia na afairethoun diplotupa--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE StagingCataskevasticha.dbo.Sales
ADD RowVersionColumn rowversion;

ALTER TABLE FactProduction
ADD	[version] BIGINT;

ALTER TABLE FactProduction
ADD ID INT IDENTITY(1,1);

ALTER TABLE StagingCataskevasticha.dbo.Sales
ADD ID INT IDENTITY(1,1);


SELECT * FROM FactProduction;
SELECT * FROM StagingCataskevasticha.dbo.Sales;

--UPDATE FACTPRODUCTION WITH VERSION--
WITH Result (ProductKey, OrderID, ProductStatus, RowIsCurrent, RowVersionColumn) AS
    (
        SELECT 
	         p.ProductKey, s.OrderID, s.ProductStatus, p.RowIsCurrent, s.RowVersionColumn
        FROM StagingCataskevasticha.dbo.Sales s
	        INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
		WHERE p.RowIsCurrent=1
    )
UPDATE FactProduction
SET FactProduction.[version] = CAST(re.RowVersionColumn AS BIGINT)
--SET FactProduction.[version] = re.RowVersionColumn
FROM Result re
WHERE FactProduction.OrderID = re.OrderID AND FactProduction.ProductKey = re.ProductKey AND FactProduction.ProductStatus = re.ProductStatus;

CREATE CLUSTERED INDEX IX_FactProduction_Version 
ON FactProduction ([version] ASC);

SELECT * FROM FactProduction;
SELECT * FROM StagingCataskevasticha.dbo.Sales;

---auta to sql commands mono an exoun afairethei ta diplotupa apo ton factproduction kathe fora pou afairountai
UPDATE FactProduction
SET [version] = (SELECT MAX(CAST(RowVersionColumn AS BIGINT)) FROM StagingCataskevasticha.dbo.Sales) --14091  --it is updated to 14091 epeidh exoun diagrafei ta diplotupa alla uparxei row me ROWCOLUMNVERSION 14091 sto table StagingCataskevasticha.dbo.Sales..den prepei na eisaxthei auto to row sto table FactProduction me to method RowVersion
WHERE [version] = (SELECT MAX([version]) FROM FactProduction); --= 60;    an exoun afairethei ta diplotupa, kathe fora pou afairountai


--Incremental loading--

WITH ProductionData AS (
    SELECT 
        rwp.ProductSKU,
        rw.RawMaterialKey,
        rwp.Quantity,
        rw.RowIsCurrent
    FROM StagingCataskevasticha.dbo.Production rwp
    INNER JOIN DimRawMaterial rw ON rwp.RawMaterialID = rw.RawMaterialID
),
Result AS (
    SELECT 
        p.ProductKey,
        pd.RawMaterialKey,
        s.OrderID,
        s.ProductStatus,
        CAST(FORMAT(s.RequestDate, 'yyyyMMdd') AS INT) AS InProcessDateKey, 
        CAST(FORMAT(s.ProductDoneDate, 'yyyyMMdd') AS INT) AS CompletedDateKey,
        pd.Quantity,
        CAST(s.[RowVersionColumn] AS BIGINT) AS RowVersionColumn -- Assuming s.[RowVersionColumn] exists in StagingCataskevasticha.dbo.Sales
    FROM StagingCataskevasticha.dbo.Sales s
    INNER JOIN DimProduct p ON s.ProductSKU = p.ProductSKU
    INNER JOIN ProductionData pd ON s.ProductSKU = pd.ProductSKU
    WHERE p.RowIsCurrent = 1 AND pd.RowIsCurrent = 1
),
MaxRowVersion AS (
    SELECT COALESCE(MAX([version]), 0) AS MaxRowVersionColumn
    FROM FactProduction
)
INSERT INTO FactProduction(ProductKey, RawMaterialKey, OrderID, ProductStatus, InProcessDateKey, CompletedDateKey, Quantity, [version])
SELECT 
    r.ProductKey,
	r.RawMaterialKey,
    r.OrderID,
	r.ProductStatus,
    r.InProcessDateKey,
    r.CompletedDateKey,
    r.Quantity,
    r.RowVersionColumn
FROM Result r
WHERE r.RowVersionColumn > (SELECT MaxRowVersionColumn FROM MaxRowVersion); 
--ORDER BY r.RowVersionColumn;--AND (CAST(r.[RowVersionColumn] AS BIGINT) - (SELECT MaxRowVersionColumn FROM MaxRowVersion) > 1);    apo thn deuterh eisagwgh prepei na vgei to + 1 sto WHERE

INSERT INTO
StagingCataskevasticha.dbo.Sales(ProductSKU, OrderID, ProductionEmployeeID, CustomerID, LogisticsPartner, Quantity, RequestDate, StatusDate, OrderStatus, ProductStatus, ProductDoneDate)
VALUES ('BRK123', 16, 1, 1,'FedEx', 1000, '2025-03-15 00:00:00.000', '2025-03-20 00:00:00.000', 'In Process', 'In Production', DATEADD(DAY, 7, CONVERT(DATE, '2025-03-15 00:00:00.000')));

--an exoun afairethei ta diplotupa apo to factproduction kai trexei insert into prepei na xanaafairethoun ta diplotupa apo to factproduction(target table) kathws uparxoun sto StagingCataskevasticha.dbo.Sales(source table)
--kai epaneisagontai sto factproduction, ektos ki an ginoun delete kai apo to StagingCataskevasticha.dbo.Sales(source table)--sto paradeigma an apla eisaxthoun rows sto table StagingCataskevasticha.dbo.Sales den xreiazetai
--sql commands gia na afairethoun diplotupa--
-----------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE FactProduction
DROP COLUMN ID;

ALTER TABLE StagingCataskevasticha.dbo.Sales
DROP COLUMN ID;

--SELECT * FROM FactProduction;
--WHERE ID=91;
--WHERE ID=4;

--SELECT * FROM FactProduction
--ORDER BY [version];

SELECT * FROM StagingCataskevasticha.dbo.Sales;

SELECT * FROM FactProduction;

DELETE FROM FactProduction
--WHERE ID>50;
WHERE ID>60;
--WHERE ID=4;
DELETE FROM StagingCataskevasticha.dbo.Sales where Quantity=1000;



ALTER TABLE StagingCataskevasticha.dbo.Sales
DROP COLUMN RowVersionColumn;

DROP INDEX IX_FactProduction_Version ON FactProduction;

ALTER TABLE FactProduction
DROP COLUMN [version];

Truncate table FactProduction;

--DROP TABLE FactProduction;