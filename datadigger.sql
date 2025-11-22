CREATE DATABASE DataDigger;
USE DataDigger;

CREATE TABLE Purchasers(
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Purchasers(CustomerID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(150) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    SubTotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Purchasers (Name, Email, Address) VALUES
('Emma Johnson', 'emma.johnson@gmail.com', 'New York, USA'),
('Liam Anderson', 'liam.anderson@gmail.com', 'Sydney, Australia'),
('Sofia Martinez', 'sofia.martinez@gmail.com', 'Madrid, Spain'),
('Noah Müller', 'noah.muller@gmail.com', 'Berlin, Germany'),
('Isabella Rossi', 'isabella.rossi@gmail.com', 'Rome, Italy');

INSERT INTO Products (ProductName, Price, Stock) VALUES
('Wireless Mouse', 799, 50),
('Keyboard', 1299, 30),
('USB-C Cable', 499, 100),
('Bluetooth Speaker', 1999, 20),
('Smartwatch', 5999, 10);

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, CURDATE() - INTERVAL 5 DAY, 1798),
(2, CURDATE() - INTERVAL 15 DAY, 5999),
(1, CURDATE() - INTERVAL 2 DAY, 1299),
(3, CURDATE() - INTERVAL 40 DAY, 1999),
(4, CURDATE() - INTERVAL 10 DAY, 499);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, SubTotal) VALUES
(1, 1, 2, 1598),
(2, 5, 1, 5999),
(3, 2, 1, 1299),
(4, 4, 1, 1999),
(5, 3, 1, 499);


-- Update purchaser
SELECT * FROM Purchasers WHERE Name = 'Emma Johnson';
UPDATE Purchasers
SET Address = 'Updated Address Example'
WHERE Name LIKE 'Emma Johnson';

-- Delete purchaser
DELETE FROM Purchasers WHERE CustomerID = 5;

-- Update an order
UPDATE Orders SET TotalAmount = 3399 WHERE OrderID = 1;

-- Delete order (remove details first)
DELETE FROM OrderDetails WHERE OrderID = 2;
DELETE FROM Orders WHERE OrderID = 2;



-- All purchasers
SELECT * FROM Purchasers;

-- Check updated purchaser
SELECT * FROM Purchasers WHERE Name = 'Emma Johnson';

-- Orders from customer 1
SELECT * FROM Orders WHERE CustomerID = 1;

-- Recent orders (last 30 days)
SELECT * FROM Orders
WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;

-- Order statistics
SELECT
    MAX(TotalAmount) AS HighestOrder,
    MIN(TotalAmount) AS LowestOrder,
    ROUND(AVG(TotalAmount), 2) AS AverageOrder
FROM Orders;

-- Products high → low price
SELECT * FROM Products ORDER BY Price DESC;

-- Update product price
UPDATE Products SET Price = 6499 WHERE ProductID = 5;

-- Delete products with zero stock
UPDATE Products SET Stock = 0 WHERE ProductID = 3;
DELETE FROM Products WHERE Stock = 0;

-- Products in price range
SELECT * FROM Products WHERE Price BETWEEN 500 AND 2000;

-- Most expensive + cheapest product
SELECT
    (SELECT ProductName FROM Products ORDER BY Price DESC LIMIT 1) AS MostExpensive,
    (SELECT ProductName FROM Products ORDER BY Price ASC LIMIT 1) AS Cheapest;

-- Order details with product name
SELECT od.*, p.ProductName 
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE od.OrderID = 1;

-- Total revenue
SELECT ROUND(SUM(SubTotal), 2) AS TotalRevenue FROM OrderDetails;

-- Top 3 best-selling products
SELECT p.ProductName, SUM(od.Quantity) AS TotalQty
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQty DESC
LIMIT 3;

-- Times a specific product was sold (ProductID = 4)
SELECT p.ProductName, COUNT(*) AS TimesSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductID = 4
GROUP BY p.ProductName;
