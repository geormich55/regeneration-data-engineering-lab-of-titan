USE Cataskevasticha;

-- Insert data into Products table
INSERT INTO Products (ProductSKU, ProductName, Length, Width, Thickness, Weight, SurfaceFinish, Color, ComplianceStandards, CostPerUnit, ConstructionTimeInDays)
VALUES
('BRK123', 'Brick', 10.00, 5.00, 0.50, 2.00, 'Matte', 'Red', 'ISO 9001', 15.00, 7),
('BLK456', 'Block', 12.00, 6.00, 0.75, 3.00, 'Glossy', 'Blue', 'ASTM C90', 20.00, 5),
('CON789', 'Concrete', 8.00, 4.00, 0.60, 1.50, 'Matte', 'Gray', 'ISO 14001', 10.00, 6),
('CEM321', 'Cement', 15.00, 7.00, 1.00, 4.00, 'Glossy', 'Gray', 'ASTM C150', 25.00, 8),
('STL654', 'Steel', 11.00, 5.50, 0.65, 2.20, 'Matte', 'Silver', 'ISO 9001', 18.00, 7),
('MET987', 'Metal Product', 9.00, 4.50, 0.70, 1.80, 'Glossy', 'Gold', 'ISO 14001', 14.00, 5),
('ROF543', 'Roofing', 13.00, 6.50, 0.85, 2.50, 'Matte', 'Brown', 'ASTM D7158', 22.00, 6),
('INS876', 'Insulation Material', 10.50, 5.25, 0.55, 2.10, 'Glossy', 'White', 'ASTM C518', 16.00, 8),
('TIL234', 'Tile', 12.50, 6.25, 0.80, 3.10, 'Matte', 'Blue', 'ISO 9001', 19.00, 7),
('BRD567', 'Board', 14.00, 7.00, 1.10, 4.20, 'Glossy', 'White', 'ASTM C208', 23.00, 5),
('GLS890', 'Glass', 11.50, 5.75, 0.90, 2.30, 'Matte', 'Transparent', 'ISO 14001', 17.00, 6),
('PLY012', 'Plywood', 9.50, 4.75, 0.75, 1.90, 'Glossy', 'Brown', 'ASTM D3043', 13.00, 7),
('PLB321', 'Plasterboard', 10.00, 5.00, 0.50, 1.50, 'Matte', 'White', 'EN 520', 12.00, 5),
('ASB654', 'Asbestos Cement', 11.00, 6.00, 0.75, 3.50, 'Glossy', 'Gray', 'ISO 9001', 22.00, 6),
('PVC987', 'PVC Panel', 9.00, 4.50, 0.70, 1.20, 'Glossy', 'White', 'ASTM D1784', 14.00, 4);

-- Insert data into Suppliers table
INSERT INTO Suppliers (SupplierName, ContactInfo)
VALUES
('AlphaBeta Supplies', 'contact@absupplies.com'),
('Edit Materials', 'info@editmaterials.com'),
('Quality Builders', 'support@qualitybuilders.com'),
('Delta Industrial', 'sales@deltaindustrial.com'),
('Pro Build', 'info@probuild.com'),
('Elite Construction', 'contact@eliteconstruction.com'),
('Top Grade Supplies', 'support@topgradesupplies.com'),
('BuildTech', 'info@buildtech.com'),
('Prime Materials', 'contact@primematerials.com'),
('HighTech Supplies', 'support@hightechsupplies.com'),
('MegaBuild', 'info@megabuild.com'),
('SuperBuild', 'contact@superbuild.com'),
('UltraMaterials', 'support@ultramaterials.com'),
('EcoBuild', 'info@ecobuild.com'),
('GreenBuild', 'contact@greenbuild.com');


-- Insert data into RawMaterials table
INSERT INTO RawMaterials (RawMaterialName, SupplierID)
VALUES
('Clay', 1),
('Cement Powder', 2),
('Sand', 3),
('Gravel', 4),
('Steel Rods', 5),
('Insulation Foam', 6),
('Wood', 7),
('Glass Fiber', 8),
('Plastic', 9),
('Aluminum', 10),
('Copper', 11),
('Rubber', 12),
('Gypsum', 13),
('Asbestos', 14),
('PVC', 15);


-- Insert data into Customers table
INSERT INTO Customers (CustomerName, Email, Phone, CustomerAddress)
VALUES
('John Doe', 'john.doe@example.com', '123-456-7890', '123 Main St, City A'),
('Jane Smith', 'jane.smith@example.com', '234-567-8901', '456 Oak St, City B'),
('Mike Johnson', 'mike.johnson@example.com', '345-678-9012', '789 Pine St, City C'),
('Emily Davis', 'emily.davis@example.com', '456-789-0123', '101 Maple St, City D'),
('Chris Brown', 'chris.brown@example.com', '567-890-1234', '202 Cedar St, City E'),
('Patricia Miller', 'patricia.miller@example.com', '678-901-2345', '303 Birch St, City F'),
('Robert Wilson', 'robert.wilson@example.com', '789-012-3456', '404 Elm St, City G'),
('Linda Martinez', 'linda.martinez@example.com', '890-123-4567', '505 Ash St, City H'),
('Barbara Anderson', 'barbara.anderson@example.com', '901-234-5678', '606 Walnut St, City I'),
('Michael Thomas', 'michael.thomas@example.com', '012-345-6789', '707 Chestnut St, City J'),
('Elizabeth Jackson', 'elizabeth.jackson@example.com', '123-456-7891', '808 Spruce St, City K'),
('David White', 'david.white@example.com', '234-567-8902', '909 Cypress St, City L'),
('Susan Harris', 'susan.harris@example.com', '345-678-9013', '1010 Sycamore St, City M'),
('James Clark', 'james.clark@example.com', '456-789-0124', '1111 Beech St, City N'),
('Mary Lewis', 'mary.lewis@example.com', '567-890-1235', '1212 Redwood St, City O');


-- Insert data into ProductionTeam table
INSERT INTO ProductionTeam (EmployeeName)
VALUES
('Alice Brown'),
('Bob Martin'),
('Charlie Wilson'),
('David Lee'),
('Eva Green'),
('Frank Harris'),
('Grace Lee'),
('Henry Thompson'),
('Ivy Johnson'),
('Jack Davis'),
('Kathy Martinez'),
('Leo King'),
('Mia Turner'),
('Nick Carter'),
('Olivia Scott');


-- Insert data into Orders table
INSERT INTO Orders (CustomerID, RequestDate, ProductionEmployeeID, LogisticsPartner)
VALUES
(1, '2023-11-05', 1, 'FedEx'),
(2, '2023-11-10', 2, 'UPS'),
(3, '2023-11-15', 3, 'DHL'),
(4, '2023-11-25', 4, 'TNT'),
(5, '2023-12-05', 5, 'FedEx'),
(6, '2023-12-10', 6, 'UPS'),
(7, '2023-12-15', 7, 'DHL'),
(8, '2023-12-20', 8, 'TNT'),
(9, '2023-12-25', 9, 'FedEx'),
(10, '2024-01-05', 10, 'UPS'),
(11, '2024-01-10', 11, 'DHL'),
(12, '2024-01-15', 12, 'TNT'),
(13, '2024-01-20', 13, 'FedEx'),
(14, '2024-02-05', 14, 'UPS'),
(15, '2024-02-10', 15, 'DHL'),
(15, '2024-02-15', 10, 'UPS'),
(10, '2024-03-05', 11, 'DHL'),
(8, '2024-03-10', 12, 'TNT'),
(9, '2024-03-15', 13, 'FedEx'),
(8, '2024-03-20', 14, 'UPS'),
(11, '2024-04-05', 15, 'DHL'),
(11, '2024-04-10', 3, 'DHL'),
(12, '2024-04-20', 4, 'TNT'),
(12, '2024-05-07', 5, 'FedEx'),
(2, '2024-05-15', 6, 'UPS'),
(2, '2024-05-22', 2, 'UPS'),
(9, '2024-06-08', 3, 'DHL'),
(6, '2024-06-12', 4, 'TNT'),
(8, '2024-06-15', 10, 'UPS'),
(7, '2024-06-19', 5, 'FedEx');

select * from Orders;

-- Insert data into OrderStatusHistory table
INSERT INTO OrderStatusHistory (OrderStatus, StatusDate, OrderID)
VALUES
('In Process', '2023-11-05', 1),
('In Process', '2023-11-10', 2),
('In Delivery', '2023-11-12', 1), -- Assuming max construction time is 7 days
('In Process', '2023-11-15', 3),
('Complete', '2023-11-16', 1), -- 5 days after delivery starts
('In Delivery', '2023-11-20', 2), -- Assuming max construction time is 10 days
('In Process', '2023-11-25', 4),
('In Delivery', '2023-11-25', 3), -- Assuming max construction time is 10 days
('Complete', '2023-11-28', 2), -- 5 days after delivery starts
('Cancelled', '2023-11-29', 4), -- Canceled order
('Complete', '2023-11-30', 3), -- 5 days after delivery starts
('In Process', '2023-12-05', 5),
('In Process', '2023-12-10', 6),
('In Delivery', '2023-12-15', 5), -- Assuming max construction time is 10 days
('In Process', '2023-12-15', 7),
('In Delivery', '2023-12-18', 6), -- Assuming max construction time is 8 days
('In Process', '2023-12-20', 8),
('Complete', '2023-12-22', 5), -- 5 days after delivery starts
('Complete', '2023-12-23', 6), -- 5 days after delivery starts
('In Delivery', '2023-12-25', 7), -- Assuming max construction time is 10 days
('In Process', '2023-12-25', 9),
('Cancelled', '2023-12-28', 8), -- Canceled order
('Complete', '2023-12-30', 7), -- 5 days after delivery starts
('In Delivery', '2024-01-02', 9), -- Assuming max construction time is 7 days
('In Process', '2024-01-05', 10),
('Complete', '2024-01-07', 9), -- 5 days after delivery starts
('In Process', '2024-01-10', 11),
('In Delivery', '2024-01-14', 10), -- Assuming max construction time is 9 days
('In Process', '2024-01-15', 12),
('Complete', '2024-01-17', 10), -- 5 days after delivery starts
('In Delivery', '2024-01-20', 11), -- Assuming max construction time is 10 days
('In Process', '2024-01-20', 13),
('Cancelled', '2024-01-22', 12), -- Canceled order
('Complete', '2024-01-25', 11), -- 5 days after delivery starts
('In Delivery', '2024-01-27', 13), -- Assuming max construction time is 7 days
('Complete', '2024-02-01', 13), -- 5 days after delivery starts
('In Process', '2024-02-05', 14),
('In Process', '2024-02-10', 15),
('In Delivery', '2024-02-15', 14), -- Assuming max construction time is 10 days
('In Process', '2024-02-15', 16),
('In Delivery', '2024-02-18', 15), -- Assuming max construction time is 8 days
('Complete', '2024-02-20', 14), -- 5 days after delivery starts
('In Delivery', '2024-02-22', 16), -- Assuming max construction time is 7 days
('Complete', '2024-02-23', 15), -- 5 days after delivery starts
('Complete', '2024-03-01', 16), -- 9 days after delivery starts
('In Process', '2024-03-05', 17),
('In Process', '2024-03-10', 18),
('In Delivery', '2024-03-12', 17), -- Assuming max construction time is 7 days
('In Process', '2024-03-15', 19),
('Complete', '2024-03-17', 17), -- 5 days after delivery starts
('In Process', '2024-03-20', 20),
('In Delivery', '2024-03-20', 18), -- Assuming max construction time is 10 days
('In Delivery', '2024-03-25', 19), -- Assuming max construction time is 10 days
('Complete', '2024-03-27', 18), -- 7 days after delivery starts
('In Delivery', '2024-03-30', 20), -- Assuming max construction time is 10 days
('Complete', '2024-03-31', 19), -- 6 days after delivery starts
('Complete', '2024-04-05', 20), -- 6 days after delivery starts
('In Process', '2024-04-05', 21),
('In Process', '2024-04-10', 22),
('In Delivery', '2024-04-13', 21), -- Assuming max construction time is 8 days
('Complete', '2024-04-18', 21), -- 5 days after delivery starts
('In Delivery', '2024-04-20', 22), -- Assuming max construction time is 10 days
('In Process', '2024-04-20', 23),
('Complete', '2024-04-25', 22), -- 5 days after delivery starts
('In Delivery', '2024-04-27', 23), -- Assuming max construction time is 7 days
('Complete', '2024-05-04', 23), -- 7 days after delivery starts
('In Process', '2024-05-07', 24),
('In Process', '2024-05-15', 25),
('In Delivery', '2024-05-18', 24), -- Assuming max construction time is 11 days
('In Process', '2024-05-22', 26),
('In Delivery', '2024-05-22', 25), -- Assuming max construction time is 7 days
('Complete', '2024-05-28', 24), -- 10 days after delivery starts
('In Delivery', '2024-06-02', 26), -- Assuming max construction time is 11 days
('Complete', '2024-06-03', 25), -- 12 days after delivery starts
('In Process', '2024-06-08', 27),
('In Process', '2024-06-12', 28),
('In Delivery', '2024-06-15', 27), -- Assuming max construction time is 7 days
('In Process', '2024-06-15', 29),
('In Process', '2024-06-19', 30);


-- Insert data into OrderProductList table
INSERT INTO OrdersList (OrderID, ProductSKU, ProductStatus, Quantity)
VALUES
(1, 'BRK123', 'In Production', 100),
(1, 'BLK456', 'In Production', 200),
(2, 'CON789', 'In Production', 150),
(2, 'CEM321', 'In Production', 250),
(3, 'STL654', 'In Production', 300),
(3, 'MET987', 'In Production', 100),
(4, 'ROF543', 'In Production', 50),
(4, 'INS876', 'In Production', 80),
(5, 'TIL234', 'In Production', 120),
(5, 'BRD567', 'In Production', 130),
(6, 'GLS890', 'In Production', 140),
(6, 'PLY012', 'In Production', 150),
(7, 'PLB321', 'In Production', 160),
(7, 'ASB654', 'In Production', 170),
(8, 'PVC987', 'In Production', 180),
(8, 'BRK123', 'In Production', 190),
(9, 'BLK456', 'In Production', 200),
(9, 'CON789', 'In Production', 210),
(10, 'CEM321', 'In Production', 220),
(10, 'STL654', 'In Production', 230),
(11, 'MET987', 'In Production', 240),
(11, 'ROF543', 'In Production', 250),
(12, 'INS876', 'In Production', 260),
(12, 'TIL234', 'In Production', 270),
(13, 'BRD567', 'In Production', 280),
(13, 'GLS890', 'In Production', 290),
(14, 'PLY012', 'In Production', 300),
(14, 'PLB321', 'In Production', 310),
(15, 'ASB654', 'In Production', 320),
(15, 'PVC987', 'In Production', 330),
(16, 'BRK123', 'In Production', 150),
(16, 'BLK456', 'In Production', 250),
(17, 'CON789', 'In Production', 200),
(17, 'CEM321', 'In Production', 300),
(18, 'STL654', 'In Production', 350),
(18, 'MET987', 'In Production', 150),
(19, 'ROF543', 'In Production', 100),
(19, 'INS876', 'In Production', 120),
(20, 'TIL234', 'In Production', 160),
(20, 'BRD567', 'In Production', 170),
(21, 'GLS890', 'In Production', 180),
(21, 'PLY012', 'In Production', 190),
(22, 'PLB321', 'In Production', 200),
(22, 'ASB654', 'In Production', 210),
(23, 'PVC987', 'In Production', 220),
(23, 'BRK123', 'In Production', 230),
(24, 'BLK456', 'In Production', 240),
(24, 'CON789', 'In Production', 250),
(25, 'CEM321', 'In Production', 260),
(25, 'STL654', 'In Production', 270),
(26, 'MET987', 'In Production', 280),
(26, 'ROF543', 'In Production', 290),
(27, 'INS876', 'In Production', 300),
(27, 'TIL234', 'In Production', 310),
(28, 'BRD567', 'In Production', 320),
(28, 'GLS890', 'In Production', 330),
(29, 'PLY012', 'In Production', 340),
(29, 'PLB321', 'In Production', 350),
(30, 'INS876', 'In Production', 280),
(30, 'BLK456', 'In Production', 230);

-- Insert data into Needs table
INSERT INTO Needs (Quantity, RawMaterialID, ProductSKU)
VALUES
(1000, 1, 'BRK123'),   
(900, 2, 'BLK456'),    
(850, 3, 'CON789'),     
(750, 4, 'CEM321'),    
(950, 5, 'STL654'),    
(700, 6, 'MET987'),     
(300, 7, 'ROF543'),     
(200, 8, 'INS876'),     
(150, 9, 'TIL234'),     
(80, 10, 'BRD567'),     
(500, 11, 'GLS890'),    
(400, 12, 'PLY012'),    
(650, 13, 'PLB321'),   
(850, 14, 'ASB654'),   
(900, 15, 'PVC987');    