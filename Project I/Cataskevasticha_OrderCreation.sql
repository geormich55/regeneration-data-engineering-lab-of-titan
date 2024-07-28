-- a. Create an order:

-- First, let's assume the customer ID and production employee ID are known
-- Let's assume the customer ID is 1 and the production employee ID is 1, also assume the logistics partner is FedEx.

-- Insert into the Orders table to create the order
INSERT INTO Orders (CustomerID, RequestDate,ProductionEmployeeID, LogisticsPartner)
VALUES (1, GETDATE(),1, 'FedEx');

-- Now, let's insert into the Orders List table to specify the products and quantities for the order.
-- Let's assume the products ordered are 'BRK123', 'BLK456', and 'CON789' with quantities 100, 200, and 150 respectively.
INSERT INTO OrdersList (OrderID, ProductSKU, Quantity)
VALUES (SCOPE_IDENTITY(), 'BRK123', 100),
       (SCOPE_IDENTITY(), 'BLK456', 200),
       (SCOPE_IDENTITY(), 'CON789', 150);


-- Now, let's insert into the Orders History List table to log a new order insertion or manipulation.
-- Lets assume we insert our first order

INSERT INTO OrderStatusHistory (OrderID, OrderStatus, StatusDate)
VALUES (1, 'In Process', GETDATE());


-- b. Finalize production:

-- Assuming all products in an order are produced and ready for delivery
-- Update the ProductStatus in the OrderProductList table to 'Complete'
UPDATE OrdersList
SET ProductStatus = 'Complete'
WHERE OrderID = 1 AND ProductSKU = 'BLK456' ; 

-- Update the whole order when all products are completed
UPDATE Orders
SET OrderStatus = 'In Delivery'
WHERE OrderID not in (select distinct OrderID from OrdersList where ProductStatus = 'In production') ;

-- c. Finalize an order and delivery:

-- Assuming the order is ready for delivery
-- Update the OrderStatus in the Orders table to 'Complete'
UPDATE Orders
SET OrderStatus = 'Complete' 
WHERE OrderID = 1; 