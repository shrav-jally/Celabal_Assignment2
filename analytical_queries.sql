-- 1. Create Database
CREATE DATABASE IF NOT EXISTS ShopEaseDB;
USE ShopEaseDB;

-- 2. Create Tables with Constraints
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL,
    is_premium BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_customers_city ON customers (city);
CREATE INDEX idx_customers_state ON customers (state);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    stock_qty INT NOT NULL CHECK (stock_qty >= 0)
);

CREATE INDEX idx_products_category ON products (category);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount DECIMAL (12,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders (status);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    discount_pct DECIMAL (5,2) DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- 3. Load Data
INSERT INTO customers VALUES
(101, 'Aarav', 'Sharma', 'aarav.s@email.com', 'Mumbai', 'Maharashtra', '2024-01-15', TRUE),
(102, 'Priya', 'Patel', 'priya.p@email.com', 'Ahmedabad', 'Gujarat', '2024-02-20', FALSE),
(103, 'Rohan', 'Gupta', 'rohan.g@email.com', 'Delhi', 'Delhi', '2024-03-10', TRUE),
(104, 'Sneha', 'Reddy', 'sneha.r@email.com', 'Hyderabad', 'Telangana', '2024-04-05', FALSE),
(105, 'Vikram', 'Singh', 'vikram.s@email.com', 'Jaipur', 'Rajasthan', '2024-05-12', TRUE),
(106, 'Ananya', 'Iyer', 'ananya.i@email.com', 'Chennai', 'Tamil Nadu', '2024-06-18', FALSE),
(107, 'Karan', 'Mehta', 'karan.m@email.com', 'Pune', 'Maharashtra', '2024-07-22', TRUE),
(108, 'Divya', 'Nair', 'divya.n@email.com', 'Kochi', 'Kerala', '2024-08-30', FALSE);

INSERT INTO products VALUES
(201, 'Wireless Earbuds', 'Electronics', 'BoAt', 1499.00, 250),
(202, 'Cotton T-Shirt', 'Clothing', 'Levi\'s', 799.00, 500),
(203, 'Smart Watch', 'Electronics', 'Noise', 2999.00, 150),
(204, 'Running Shoes', 'Clothing', 'Nike', 4599.00, 120),
(205, 'Bluetooth Speaker', 'Electronics', 'JBL', 3499.00, 200),
(206, 'Bedsheet Set', 'Home', 'Spaces', 1299.00, 300),
(207, 'Laptop Stand', 'Electronics', 'AmazonBasics', 899.00, 180),
(208, 'Cushion Covers (Set)', 'Home', 'HomeCenter', 599.00, 400);

INSERT INTO orders VALUES
(1001, 101, '2024-08-01', 'Delivered', 4498.00),
(1002, 102, '2024-08-03', 'Delivered', 799.00),
(1003, 103, '2024-08-05', 'Shipped', 7498.00),
(1004, 101, '2024-08-10', 'Delivered', 3499.00),
(1005, 104, '2024-08-12', 'Cancelled', 2999.00),
(1006, 105, '2024-08-15', 'Delivered', 5898.00),
(1007, 106, '2024-08-18', 'Pending', 1299.00),
(1008, 103, '2024-08-20', 'Delivered', 899.00),
(1009, 107, '2024-08-25', 'Shipped', 6098.00),
(1010, 108, '2024-08-28', 'Delivered', 1598.00);

INSERT INTO order_items VALUES
(5001, 1001, 201, 2, 1499.00, 0),
(5002, 1001, 207, 1, 899.00, 10),
(5003, 1002, 202, 1, 799.00, 0),
(5004, 1003, 203, 1, 2999.00, 0),
(5005, 1003, 204, 1, 4599.00, 5),
(5006, 1004, 205, 1, 3499.00, 0),
(5007, 1005, 203, 1, 2999.00, 0),
(5008, 1006, 201, 1, 1499.00, 10),
(5009, 1006, 204, 1, 4599.00, 5),
(5010, 1007, 206, 1, 1299.00, 0),
(5011, 1008, 207, 1, 899.00, 0),
(5012, 1009, 205, 1, 3499.00, 0),
(5013, 1009, 208, 2, 599.00, 15),
(5014, 1010, 206, 1, 1299.00, 0),
(5015, 1010, 208, 1, 599.00, 0);

SELECT * FROM customers;
SELECT first_name, last_name, city FROM customers;
SELECT DISTINCT category FROM products;
INSERT INTO products (product_id, product_name, category, brand, unit_price, stock_qty)
VALUES (209, 'Faulty Item', 'Electronics', 'Generic', -50.00, 10);

SELECT * FROM orders WHERE status = 'Delivered';
SELECT * FROM products WHERE category = 'Electronics' AND unit_price > 2000;
SELECT * FROM customers WHERE join_date BETWEEN '2024-01-01' AND '2024-12-31' AND state = 'Maharashtra';
SELECT * FROM orders WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25' AND status <> 'Cancelled';
SELECT * FROM orders WHERE order_date = '2024-08-15';
SELECT * FROM customers WHERE join_date >= '2024-01-01' AND join_date <= '2024-12-31';

SELECT COUNT(*) AS total_orders_placed FROM orders;
SELECT SUM(total_amount) AS total_delivered_revenue FROM orders WHERE status = 'Delivered';
SELECT category, AVG(unit_price) AS average_price FROM products GROUP BY category;
SELECT status, COUNT(order_id) AS order_count, SUM(total_amount) AS total_revenue 
FROM orders 
GROUP BY status 
ORDER BY total_revenue DESC;
SELECT category, MAX(unit_price) AS most_expensive, MIN(unit_price) AS cheapest 
FROM products 
GROUP BY category;
SELECT category, AVG(unit_price) AS average_price 
FROM products 
GROUP BY category 
HAVING AVG(unit_price) > 2000;

SELECT o.order_id, o.order_date, c.first_name, c.last_name, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
SELECT oi.order_id, p.product_name, oi.quantity, oi.unit_price, oi.discount_pct
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id;

SELECT product_name, unit_price,
       CASE 
           WHEN unit_price < 1000 THEN 'Budget'
           WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
           ELSE 'Premium'
       END AS price_tier
FROM products;
SELECT 
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS Delivered_Count,
    SUM(CASE WHEN status <> 'Delivered' THEN 1 ELSE 0 END) AS Not_Delivered_Count
FROM orders;
START TRANSACTION;

-- 1. Insert New Order Record
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 102, CURDATE(), 'Pending', 1598.00);

-- 2. Insert Associated Transactional Line Items
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES 
(5016, 1011, 207, 1, 899.00, 0),
(5017, 1011, 202, 1, 799.00, 0);

-- 3. Modify Available Stock Levels
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 207;
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 202;

-- 4. Commit to database if all operations succeed
COMMIT;

