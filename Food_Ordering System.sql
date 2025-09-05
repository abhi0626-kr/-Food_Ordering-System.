-- 1. Create the database
CREATE DATABASE FoodOrderingSystem;
USE FoodOrderingSystem;

-- 2. Create tables with proper constraints

-- Customer table
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT NOT NULL
);

-- Restaurant table
CREATE TABLE Restaurant (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL
);

-- FoodItem table
CREATE TABLE FoodItem (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id) ON DELETE CASCADE
);

-- DeliveryAgent table
CREATE TABLE DeliveryAgent (
    agent_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount > 0),
    status ENUM('pending', 'processing', 'delivered', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- OrderDetails table
CREATE TABLE OrderDetails (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES FoodItem(item_id)
);

-- Review table
CREATE TABLE Review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id)
);

-- Offer table
CREATE TABLE Offer (
    offer_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    item_id INT,
    discount_percent DECIMAL(5,2) NOT NULL CHECK (discount_percent > 0 AND discount_percent <= 100),
    valid_till DATE NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES FoodItem(item_id) ON DELETE CASCADE,
    CHECK (restaurant_id IS NOT NULL OR item_id IS NOT NULL)
);






-- Task-2 

-- Insert 5 customers
INSERT INTO Customer (name, email, phone, address) VALUES
('Abhishek', 'abhishek06kr@gmail.com', '6383221055', '120 CKC nagar, Tamilnadu'),
('Ironman', 'ironman06@gmail.com', '8765432109', '45 Park Street, Mumbai'),
('Batman', 'batman06@gmail.com', '7654321098', '78 Gandhi Nagar, Delhi'),
('Thor', 'thor06@gmail.com', '6543210987', '32 Lake View, Hyderabad'),
('Loki', 'loki06@outlook.com', '5432109876', '56 Hill Road, Pune');

-- Insert 3 restaurants
INSERT INTO Restaurant (name, location, contact_number) VALUES
('Hotal Hills', 'Tamilnadu', '08012345678'),
('Raja Rani', 'Mumbai', '02298765432'),
('Burger King', 'Delhi', '01187654321');

-- Insert 8 food items
INSERT INTO FoodItem (restaurant_id, item_name, price, category) VALUES
(1, 'Butter Chicken', 350.00, 'Main Course'),
(1, 'Garlic Naan', 50.00, 'Bread'),
(1, 'Paneer Tikka', 280.00, 'Starter'),
(2, 'Margherita Pizza', 400.00, 'Pizza'),
(2, 'Pepperoni Pizza', 450.00, 'Pizza'),
(2, 'Garlic Bread', 120.00, 'Starter'),
(3, 'Whopper Burger', 220.00, 'Burger'),
(3, 'Cheese Fries', 150.00, 'Side');

-- Insert 3 delivery agents
INSERT INTO DeliveryAgent (name, phone) VALUES
('Ramesh K', '9123456780'),
('Suresh P', '9234567890'),
('Mahesh Y', '9345678901');

-- Insert 5 orders with corresponding order details
INSERT INTO Orders (customer_id, total_amount, status) VALUES
(1, 700.00, 'delivered'),
(2, 950.00, 'processing'),
(3, 520.00, 'delivered'),
(4, 370.00, 'pending'),
(5, 820.00, 'delivered');

INSERT INTO OrderDetails VALUES
(1, 1, 2), -- 2 Butter Chicken
(1, 2, 4), -- 4 Garlic Naan
(2, 4, 1), -- 1 Margherita Pizza
(2, 6, 2), -- 2 Garlic Bread
(3, 7, 2), -- 2 Whopper Burger
(3, 8, 1), -- 1 Cheese Fries
(4, 3, 1), -- 1 Paneer Tikka
(5, 5, 2); -- 2 Pepperoni Pizza

-- Insert 3 reviews
INSERT INTO Review (customer_id, restaurant_id, rating, comments) VALUES
(1, 1, 5, 'Excellent food and service!'),
(2, 2, 4, 'Good pizza but delivery was late'),
(3, 3, 3, 'Average experience');

-- Insert 2 offers
INSERT INTO Offer (restaurant_id, item_id, discount_percent, valid_till) VALUES
(1, NULL, 15.00, '2023-12-31'), -- 15% off on entire restaurant
(NULL, 7, 20.00, '2023-11-30'); -- 20% off on Whopper Burger









-- Task-3
-- 1. Display all customers
SELECT * FROM Customer;

-- 2. List all food items along with their restaurant names
SELECT f.item_name, f.price, f.category, r.name AS restaurant_name, r.location
FROM FoodItem f
JOIN Restaurant r ON f.restaurant_id = r.restaurant_id;

-- 3. Show all orders placed by a specific customer (e.g., customer_id = 1)
SELECT o.order_id, o.order_date, o.total_amount, o.status
FROM Orders o
WHERE o.customer_id = 1;

-- 4. Find the total number of food items available in each restaurant
SELECT r.name, COUNT(f.item_id) AS total_items
FROM Restaurant r
LEFT JOIN FoodItem f ON r.restaurant_id = f.restaurant_id
GROUP BY r.restaurant_id, r.name;

-- 5. Display orders with their total amount greater than ₹500
SELECT o.order_id, c.name AS customer_name, o.total_amount, o.order_date
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
WHERE o.total_amount > 500;

-- 6. List delivery agents who have delivered more than 3 orders
ALTER TABLE Orders ADD COLUMN agent_id INT;
ALTER TABLE Orders ADD FOREIGN KEY (agent_id) REFERENCES DeliveryAgent(agent_id);

-- Update some orders with delivery agents
UPDATE Orders SET agent_id = 1 WHERE order_id IN (1, 3);
UPDATE Orders SET agent_id = 2 WHERE order_id IN (2, 5);
UPDATE Orders SET agent_id = 3 WHERE order_id = 4;

-- Now the query:
SELECT da.name, COUNT(o.order_id) AS delivered_orders
FROM DeliveryAgent da
JOIN Orders o ON da.agent_id = o.agent_id
WHERE o.status = 'delivered'
GROUP BY da.agent_id, da.name
HAVING COUNT(o.order_id) > 0; -- Changed from 3 since we only have 5 sample orders

-- 7. Show all reviews for a particular restaurant (e.g., restaurant_id = 1)
SELECT r.rating, r.comments, c.name AS customer_name, r.review_date
FROM Review r
JOIN Customer c ON r.customer_id = c.customer_id
WHERE r.restaurant_id = 1;

-- 8. Find the most expensive food item and its restaurant
SELECT f.item_name, f.price, r.name AS restaurant_name
FROM FoodItem f
JOIN Restaurant r ON f.restaurant_id = r.restaurant_id
ORDER BY f.price DESC
LIMIT 1;

-- 9. Display all offers currently valid today
SELECT o.offer_id, 
       COALESCE(r.name, fi.item_name) AS applies_to,
       o.discount_percent,
       o.valid_till
FROM Offer o
LEFT JOIN Restaurant r ON o.restaurant_id = r.restaurant_id
LEFT JOIN FoodItem fi ON o.item_id = fi.item_id
WHERE o.valid_till >= CURDATE();

-- 10. Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue FROM Orders;




-- Part A – Advanced Query Writing------------------------------------------------------------------------------

USE FoodOrderingSystem;

-- 1. Create a view named CustomerOrdersView
CREATE VIEW CustomerOrdersView AS
SELECT 
    c.name AS customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id;

-- Display the view
SELECT * FROM CustomerOrdersView;

-- 2. Display top 3 customers who spent the most on orders
SELECT 
    c.name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 3;

-- 3. Find restaurants that have not received any reviews
SELECT 
    r.restaurant_id,
    r.name AS restaurant_name,
    r.location
FROM Restaurant r
LEFT JOIN Review rev ON r.restaurant_id = rev.restaurant_id
WHERE rev.review_id IS NULL;

-- 4. Display order details with subtotal calculation
SELECT 
    o.order_id,
    f.item_name,
    od.quantity,
    f.price,
    (od.quantity * f.price) AS subtotal
FROM OrderDetails od
JOIN FoodItem f ON od.item_id = f.item_id
JOIN Orders o ON od.order_id = o.order_id
ORDER BY o.order_id;

-- 5. Find customers who ordered the most expensive food item
SELECT 
    c.customer_id,
    c.name AS customer_name,
    o.order_id,
    f.item_name,
    f.price
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN FoodItem f ON od.item_id = f.item_id
WHERE f.price = (SELECT MAX(price) FROM FoodItem);

-- 6. Show restaurants and food items with discount > 20%
SELECT 
    r.name AS restaurant_name,
    f.item_name,
    o.discount_percent,
    o.valid_till
FROM Offer o
LEFT JOIN Restaurant r ON o.restaurant_id = r.restaurant_id
LEFT JOIN FoodItem f ON o.item_id = f.item_id
WHERE o.discount_percent > 20.00
AND o.valid_till >= CURDATE();








-- Part B – Transaction Control (TCL)--------------------------------------------------

-- 1. Insert a new order with transaction control

START TRANSACTION;

-- Insert new order
INSERT INTO Orders (customer_id, total_amount, status, agent_id)
VALUES (1, 0, 'pending', 1);

-- Set and verify the variable
SET @new_order_id = LAST_INSERT_ID();
SELECT @new_order_id AS 'New Order ID';

-- Create savepoint
SAVEPOINT after_order_insert;

-- Insert order details (make sure item_ids 1 and 2 exist in your FoodItem table)
INSERT INTO OrderDetails (order_id, item_id, quantity)
VALUES 
(@new_order_id, 1, 2),
(@new_order_id, 2, 3);

-- Verify the inserts
SELECT * FROM OrderDetails WHERE order_id = @new_order_id;

-- Rollback to savepoint (this should remove the order details)
ROLLBACK TO SAVEPOINT after_order_insert;

-- Verify order details were removed
SELECT * FROM OrderDetails WHERE order_id = @new_order_id;

-- Commit the transaction (only the order remains)
COMMIT;

-- Final verification
SELECT * FROM Orders WHERE order_id = @new_order_id;
SELECT * FROM OrderDetails WHERE order_id = @new_order_id;





-- Part C – Indexes & Optimization ----------------------------------------------------------------


-- 1. Create index on email column of Customer table
CREATE INDEX idx_customer_email ON Customer(email);

-- 2. Create index on restaurant_id column of FoodItem table
CREATE INDEX idx_fooditem_restaurant ON FoodItem(restaurant_id);

-- Show existing indexes
SHOW INDEX FROM Customer;
SHOW INDEX FROM FoodItem;








-- Part D – Triggers ----------------------------------------------------------------------

-- 1. Create trigger to set status to 'Pending' on new order insertion
DELIMITER $$
CREATE TRIGGER OrderStatusTrigger
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    -- Set default status to 'pending' if not provided
    IF NEW.status IS NULL THEN
        SET NEW.status = 'pending';
    END IF;
END$$
//

DELIMITER ;

-- 2. Verify the trigger by inserting a new order
INSERT INTO Orders (customer_id, total_amount) 
VALUES (2, 250.00);

-- Check the status of the newly inserted order
SELECT order_id, status, total_amount 
FROM Orders 
ORDER BY order_id DESC 
LIMIT 1;

-- The status should automatically be set to 'pending'



-- Part E – Stored Procedures & Functions -------------------------------------------------


-- 1. Create stored procedure to add new customer
DELIMITER $$

CREATE PROCEDURE AddNewCustomer(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_address TEXT
)
BEGIN
    INSERT INTO Customer (name, email, phone, address)
    VALUES (p_name, p_email, p_phone, p_address);
    
    SELECT 'Customer added successfully!' AS message;
END$$

DELIMITER ;

-- 2. Create function to calculate order total
DELIMITER $$

CREATE FUNCTION CalculateOrderTotal(p_order_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(od.quantity * f.price) INTO total
    FROM OrderDetails od
    JOIN FoodItem f ON od.item_id = f.item_id
    WHERE od.order_id = p_order_id;
    
    RETURN COALESCE(total, 0);
END$$

DELIMITER ;

-- 3. Demonstrate the procedure and function

-- Call the procedure to insert a new customer
CALL AddNewCustomer(
    'Abhi KR', 
    'abhi.krexample.com', 
    '9177885553', 
    '120 CKC Nage, Tirupattur'
);

-- Verify the new customer was added
SELECT * FROM Customer ORDER BY customer_id DESC LIMIT 1;

-- Call the function to calculate total for a specific order
SELECT CalculateOrderTotal(1) AS order_total;

-- Compare with the stored total amount
SELECT order_id, total_amount FROM Orders WHERE order_id = 1;

-- Update order total using the function (optional)
UPDATE Orders 
SET total_amount = CalculateOrderTotal(1) 
WHERE order_id = 1;





