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
('Sand', 1),
('Gravel', 4),
('Steel Rods', 5),
('Insulation Foam', 6),
('Wood', 7),
('Glass Fiber', 8),
('Plastic', 7),
('Aluminum', 10),
('Copper', 11),
('Rubber', 12),
('Gypsum', 13),
('Asbestos', 13),
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
INSERT INTO Orders (CustomerID, RequestDate, OrderStatus, ProductionEmployeeID, LogisticsPartner)
VALUES
(1, '2024-01-15', 'In Process', 1, 'FedEx'),
(2, '2024-02-20', 'In Process', 2, 'UPS'),
(3, '2024-03-10', 'In Process', 3, 'DHL'),
(4, '2024-04-25', 'In Process', 4, 'TNT'),
(5, '2024-05-15', 'In Process', 5, 'FedEx'),
(6, '2024-06-10', 'In Process', 6, 'UPS'),
(7, '2024-07-20', 'In Process', 7, 'DHL'),
(8, '2024-08-15', 'In Process', 8, 'TNT'),
(9, '2024-09-10', 'In Process', 9, 'FedEx'),
(10, '2024-10-05', 'In Process', 10, 'UPS'),
(11, '2024-11-15', 'In Process', 11, 'DHL'),
(12, '2024-12-10', 'In Process', 12, 'TNT'),
(13, '2025-01-15', 'In Process', 13, 'FedEx'),
(14, '2025-02-20', 'In Process', 14, 'UPS'),
(15, '2025-03-10', 'In Process', 15, 'DHL');

-- Insert data into OrderStatusHistory table
INSERT INTO OrderStatusHistory (OrderStatus, StatusDate, OrderID)
VALUES
('In Process', '2024-01-15', 1),
('In Delivery', '2024-01-20', 1),
('Complete', '2024-01-25', 1),
('In Process', '2024-02-20', 2),
('In Delivery', '2024-02-25', 2),
('Complete', '2024-03-01', 2),
('In Process', '2024-03-10', 3),
('In Delivery', '2024-03-15', 3),
('Complete', '2024-03-20', 3),
('In Process', '2024-04-25', 4),
('In Delivery', '2024-04-30', 4),
('Complete', '2024-05-05', 4),
('In Process', '2024-05-15', 5),
('In Delivery', '2024-05-20', 5),
('Complete', '2024-05-25', 5),
('In Process', '2024-06-10', 6),
('In Delivery', '2024-06-15', 6),
('Complete', '2024-06-20', 6),
('In Process', '2024-07-20', 7),
('In Delivery', '2024-07-25', 7),
('Complete', '2024-07-30', 7),
('In Process', '2024-08-15', 8),
('In Delivery', '2024-08-20', 8),
('Complete', '2024-08-25', 8),
('In Process', '2024-09-10', 9),
('In Delivery', '2024-09-15', 9),
('Complete', '2024-09-20', 9),
('In Process', '2024-10-05', 10),
('In Delivery', '2024-10-10', 10),
('Complete', '2024-10-15', 10),
('In Process', '2024-11-15', 11),
('In Delivery', '2024-11-20', 11),
('Complete', '2024-11-25', 11),
('In Process', '2024-12-10', 12),
('In Delivery', '2024-12-15', 12),
('Complete', '2024-12-20', 12),
('In Process', '2025-01-15', 13),
('In Delivery', '2025-01-20', 13),
('Complete', '2025-01-25', 13),
('In Process', '2025-02-20', 14),
('In Delivery', '2025-02-25', 14),
('Complete', '2025-03-01', 14),
('In Process', '2025-03-10', 15),
('In Delivery', '2025-03-15', 15),
('Complete', '2025-03-20', 15);

-- Insert data into OrderProductList table
INSERT INTO OrdersList (OrderID, ProductSKU, Quantity)
VALUES
(1, 'BRK123', 100),
(1, 'BLK456', 200),
(2, 'CON789', 150),
(2, 'CEM321', 250),
(3, 'STL654',  300),
(3, 'MET987', 100),
(4, 'ROF543', 50),
(4, 'INS876', 80),
(5, 'TIL234', 120),
(5, 'BRD567', 130),
(6, 'GLS890', 140),
(6, 'PLY012', 150),
(7, 'PLB321', 160),
(7, 'ASB654', 170),
(8, 'PVC987', 180),
(8, 'BRK123', 190),
(9, 'BLK456', 200),
(9, 'CON789', 210),
(10, 'CEM321', 220),
(10, 'STL654', 230),
(11, 'MET987', 240),
(11, 'ROF543', 250),
(12, 'INS876',  260),
(12, 'TIL234', 270),
(13, 'BRD567', 280),
(13, 'GLS890', 290),
(14, 'PLY012', 300),
(14, 'PLB321', 310),
(15, 'ASB654', 320),
(15, 'PVC987', 330);

-- Insert data into Needs table
INSERT INTO Needs (Quantity, RawMaterialID, ProductSKU)
VALUES
(500, 1, 'BRK123'),
(300, 2, 'BLK456'),
(400, 3, 'CON789'),
(250, 4, 'CEM321'),
(350, 5, 'STL654'),
(450, 6, 'MET987'),
(200, 1, 'ROF543'),
(150, 2, 'INS876'),
(100, 3, 'TIL234'),
(50, 4, 'BRD567'),
(120, 5, 'GLS890'),
(80, 6, 'PLY012'),
(600, 7, 'PLB321'),
(700, 8, 'ASB654'),
(800, 9, 'PVC987');
