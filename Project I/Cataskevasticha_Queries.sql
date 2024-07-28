
-- a. List of all products ordered yesterday (so that production can start):
SELECT 
	op.ProductSKU, 
	p.ProductName,
	op.ProductStatus,
	op.Quantity,
	o.RequestDate
FROM OrdersList op
JOIN Orders o ON op.OrderID = o.OrderID
JOIN Products p ON op.ProductSKU = p.ProductSKU
WHERE o.RequestDate = DATEADD(DAY, -91, CONVERT(DATE, GETDATE())); -- -1 instead of -91

-- b2. List of all finished orders ready to deliver:
SELECT 
	OrderID, 
	OrderStatus,
	RequestDate, 
	LogisticsPartner
FROM Orders
WHERE OrderStatus = 'In Delivery';


-- c. List of all orders per customer, completed, pending, cancelled:
SELECT 
    c.CustomerName,
    SUM(CASE WHEN o.OrderStatus = 'Complete' THEN 1 ELSE 0 END) AS CompletedOrders,
    SUM(CASE WHEN o.OrderStatus in ('In Process','In Delivery')  THEN 1 ELSE 0 END) AS PendingOrders,
    SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
FROM Orders o
LEFT JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY 
	c.CustomerName;


-- d. List of all products with quantities, ordered and delivered, ordered and pending, cancelled:
SELECT 
    p.ProductSKU,
    p.ProductName,
    SUM(CASE WHEN op.ProductStatus = 'In Production' THEN op.Quantity ELSE 0 END) AS OrderedAndPending,
    SUM(CASE WHEN o.OrderStatus = 'Complete' THEN op.Quantity ELSE 0 END) AS OrderedAndDelivered,
    SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN op.Quantity ELSE 0 END) AS Cancelled
FROM Products p
LEFT JOIN OrdersList op ON p.ProductSKU = op.ProductSKU
LEFT JOIN Orders o ON op.OrderID = o.OrderID
GROUP BY 
	p.ProductSKU, 
	p.ProductName;


-- e. List of orders per production team employee, completed, pending, cancelled:
SELECT 
    pt.EmployeeName,
    SUM(CASE WHEN o.OrderStatus = 'Complete' THEN 1 ELSE 0 END) AS CompletedOrders,
    SUM(CASE WHEN o.OrderStatus = 'In Process' THEN 1 ELSE 0 END) AS PendingOrders,
    SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
FROM ProductionTeam pt
LEFT JOIN Orders o ON pt.ProductionEmployeeID = o.ProductionEmployeeID
GROUP BY 
	pt.EmployeeName;


-- f. Daily order and production report:
SELECT 
    CONVERT(DATE, o.RequestDate) AS OrderDate,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(op.Quantity) AS TotalProductsOrdered,
    SUM(CASE WHEN os.OrderStatus = 'Complete' THEN op.Quantity ELSE 0 END) AS TotalProductsProduced
FROM Orders o
LEFT JOIN OrdersList op ON o.OrderID = op.OrderID
LEFT JOIN OrderStatusHistory os ON o.OrderID = os.OrderID
GROUP BY 
	CONVERT(DATE, o.RequestDate)


-- g. List of new orders per week and month:
SELECT 
    DATEPART(ISO_WEEK, os.StatusDate) AS WeekNumber,
    COUNT(os.OrderID) AS [New Orders]
FROM OrderStatusHistory os
WHERE os.OrderStatus = 'In Process'
GROUP BY 
	DATEPART(ISO_WEEK, os.StatusDate);

SELECT 
	MONTH(os.StatusDate) as MonthNum,
    DATENAME(MONTH, os.StatusDate) AS MonthName,
    COUNT(os.OrderID) AS [New Orders]	
FROM OrderStatusHistory os
WHERE os.OrderStatus = 'In Process'
GROUP BY 
	DATENAME(MONTH, os.StatusDate),
	MONTH(os.StatusDate)
ORDER BY MONTH(os.StatusDate);


-- h. List of completed orders per week and month:
SELECT 
    DATEPART(ISO_WEEK, os.StatusDate) AS WeekNumber,
    COUNT(os.OrderID) AS [Completed Orders]
FROM OrderStatusHistory os
WHERE os.OrderStatus = 'Complete'
GROUP BY 
	DATEPART(ISO_WEEK, os.StatusDate);

SELECT 
	MONTH(os.StatusDate) as MonthNum,
    DATENAME(MONTH, os.StatusDate) AS MonthName,
    COUNT(os.OrderID) AS [Completed Orders]	
FROM OrderStatusHistory os
WHERE os.OrderStatus = 'Complete'
GROUP BY 
	DATENAME(MONTH, os.StatusDate),
	MONTH(os.StatusDate)
ORDER BY MONTH(os.StatusDate);