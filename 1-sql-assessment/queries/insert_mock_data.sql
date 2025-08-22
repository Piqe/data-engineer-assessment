-- Active: 1755678248085@@127.0.0.1@5432@db_retail
-- 1. Buat database
CREATE DATABASE db_retail;

-- 2. Tabel Branch Details
CREATE TABLE branch_details (
    branch_code VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(100),
    region_id INT,
    operation_start_date DATE,
    is_active BOOLEAN,
    max_capacity INT,
    last_renovation_date DATE
);

INSERT INTO branch_details VALUES
('B001', 'Central Store', 1, '2015-01-15', TRUE, 500, '2022-01-01'),
('B002', 'North Branch', 1, '2016-05-20', TRUE, 300, '2021-12-15'),
('B003', 'South Branch', 2, '2017-03-10', TRUE, 400, '2023-06-01'),
('B004', 'East Branch', 2, '2018-08-25', TRUE, 350, '2022-11-10'),
('B005', 'West Branch', 3, '2019-07-05', TRUE, 450, '2021-09-20'),
('B006', 'Airport Branch', 3, '2020-01-12', TRUE, 250, '2022-03-15'),
('B007', 'Mall Branch', 4, '2015-11-30', TRUE, 600, '2023-01-01'),
('B008', 'City Center', 4, '2016-06-18', TRUE, 500, '2022-05-05'),
('B009', 'Suburban Branch', 1, '2017-09-25', TRUE, 400, '2023-07-20'),
('B010', 'Downtown Branch', 2, '2018-12-12', TRUE, 550, '2022-10-10');

-- 3. Tabel Staff Records
CREATE TABLE staff_records (
    staff_id VARCHAR(15) PRIMARY KEY,
    branch_code VARCHAR(10),
    join_date DATE,
    role_code VARCHAR(5),
    base_salary DECIMAL(12,2),
    supervisor_id VARCHAR(15),
    resignation_date DATE,
    performance_score DECIMAL(3,2),
    FOREIGN KEY (branch_code) REFERENCES branch_details(branch_code)
);

INSERT INTO staff_records VALUES
('S001','B001','2016-01-10','MGR',12000000,NULL,NULL,4.5),
('S002','B001','2017-02-15','STF',8000000,'S001',NULL,4.2),
('S003','B002','2018-03-20','STF',7500000,'S004',NULL,4.0),
('S004','B002','2016-05-25','MGR',11500000,NULL,NULL,4.7),
('S005','B003','2019-06-15','STF',7000000,'S006',NULL,3.8),
('S006','B003','2017-07-10','MGR',11000000,NULL,NULL,4.3),
('S007','B004','2020-08-05','STF',6500000,'S008',NULL,3.9),
('S008','B004','2018-09-01','MGR',10800000,NULL,NULL,4.1),
('S009','B005','2019-10-10','STF',7200000,'S010',NULL,3.7),
('S010','B005','2017-11-20','MGR',11200000,NULL,NULL,4.4);

-- 4. Tabel Product Hierarchy
CREATE TABLE product_hierarchy (
    product_code VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category_l1 VARCHAR(50),
    category_l2 VARCHAR(50),
    category_l3 VARCHAR(50),
    unit_cost DECIMAL(12,2),
    unit_price DECIMAL(12,2),
    supplier_id VARCHAR(10),
    minimum_stock INT,
    is_perishable BOOLEAN
);

INSERT INTO product_hierarchy VALUES
('P001','Apple','Fruit','Fresh Fruit','Apple',2000,3000,'SUP01',50,TRUE),
('P002','Banana','Fruit','Fresh Fruit','Banana',1000,2000,'SUP01',50,TRUE),
('P003','Orange Juice','Beverage','Juice','Orange Juice',5000,7000,'SUP02',20,TRUE),
('P004','Milk','Dairy','Milk','Whole Milk',4000,6000,'SUP02',30,TRUE),
('P005','Cheddar Cheese','Dairy','Cheese','Cheddar',10000,15000,'SUP02',10,FALSE),
('P006','Rice 5kg','Grain','Rice','Premium Rice',60000,70000,'SUP03',25,FALSE),
('P007','Wheat Flour','Grain','Flour','All Purpose',25000,30000,'SUP03',15,FALSE),
('P008','Shampoo','Personal Care','Hair Care','Shampoo',15000,22000,'SUP04',10,FALSE),
('P009','Toothpaste','Personal Care','Oral Care','Toothpaste',8000,12000,'SUP04',10,FALSE),
('P010','Soap','Personal Care','Body Care','Soap Bar',5000,8000,'SUP04',20,FALSE);

-- 5. Tabel Inventory Movements
CREATE TABLE inventory_movements (
    movement_id BIGINT PRIMARY KEY,
    product_code VARCHAR(20),
    branch_code VARCHAR(10),
    transaction_type CHAR(3),
    quantity INT,
    transaction_date DATE,
    batch_number VARCHAR(20),
    expiry_date DATE,
    unit_cost_at_time DECIMAL(12,2),
    FOREIGN KEY (product_code) REFERENCES product_hierarchy(product_code),
    FOREIGN KEY (branch_code) REFERENCES branch_details(branch_code)
);

INSERT INTO inventory_movements (movement_id, product_code, branch_code, transaction_type, quantity, transaction_date, batch_number, expiry_date, unit_cost_at_time) VALUES
(1,'P001','B001','IN',100,'2025-01-01','B001-01','2025-08-01',2000),
(2,'P002','B001','OUT',120,'2025-01-02','B001-02','2025-08-03',1000),
(3,'P003','B002','IN',50,'2025-01-03','B002-01','2025-07-25',5000),
(4,'P004','B003','EXP',70,'2025-01-04','B003-01','2025-07-30',4000),
(5,'P005','B004','IN',20,'2025-01-05','B004-01','2025-12-01',10000),
(11,'P001','B001','OUT',30,'2025-06-15','B001-01','2025-08-01',2000),
(12,'P002','B001','OUT',50,'2025-07-10','B001-02','2025-08-03',1000),
(13,'P003','B002','EXP',5,'2025-06-20','B002-01','2025-07-25',5000),
(14,'P004','B003','IN',20,'2025-07-05','B003-01','2025-07-30',4000),
(15,'P005','B004','OUT',10,'2025-08-01','B004-01','2025-12-01',10000),
(16,'P006','B005','EXP',2,'2025-07-25','B005-01','2026-01-01',60000),
(17,'P007','B006','IN',15,'2025-06-30','B006-01','2026-02-01',25000),
(18,'P008','B007','OUT',5,'2025-07-15','B007-01','2026-03-01',15000),
(19,'P009','B008','IN',10,'2025-08-05','B008-01','2026-04-01',8000),
(20,'P010','B009','EXP',1,'2025-08-10','B009-01','2026-05-01',5000);



-- 6. Tabel Sales Transactions
CREATE TABLE sales_transactions (
    transaction_id VARCHAR(30) PRIMARY KEY,
    branch_code VARCHAR(10),
    transaction_date TIMESTAMP,
    staff_id VARCHAR(15),
    payment_method VARCHAR(10),
    total_amount DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    loyalty_points_earned INT,
    loyalty_points_redeemed INT,
    customer_id VARCHAR(20),
    FOREIGN KEY (branch_code) REFERENCES branch_details(branch_code),
    FOREIGN KEY (staff_id) REFERENCES staff_records(staff_id)
);

INSERT INTO sales_transactions VALUES
('T001','B001','2025-08-01 10:00:00','S002','Cash',50000,5000,10,0,'C001'),
('T002','B001','2025-08-01 11:00:00','S002','Card',30000,2000,5,0,'C002'),
('T003','B002','2025-08-02 12:30:00','S003','Cash',45000,3000,8,2,'C003'),
('T004','B003','2025-08-03 14:00:00','S005','Card',60000,4000,12,5,'C004'),
('T005','B004','2025-08-04 15:00:00','S007','Cash',35000,1000,7,0,'C005'),
('T006','B005','2025-08-05 16:00:00','S009','Card',70000,5000,15,10,'C006'),
('T007','B006','2025-08-06 17:00:00','S009','Cash',20000,0,3,0,'C007'),
('T008','B007','2025-08-07 18:00:00','S007','Card',90000,7000,20,15,'C008'),
('T009','B008','2025-08-08 19:00:00','S008','Cash',40000,2000,9,0,'C009'),
('T010','B009','2025-08-09 20:00:00','S010','Card',55000,3000,11,5,'C010');


-- 7. Tabel Sales Line Items
CREATE TABLE sales_line_items (
    transaction_id VARCHAR(30),
    line_number INT,
    product_code VARCHAR(20),
    quantity INT,
    unit_price_at_time DECIMAL(12,2),
    discount_percentage DECIMAL(5,2),
    total_line_amount DECIMAL(12,2),
    PRIMARY KEY (transaction_id, line_number),
    FOREIGN KEY (transaction_id) REFERENCES sales_transactions(transaction_id),
    FOREIGN KEY (product_code) REFERENCES product_hierarchy(product_code)
);

INSERT INTO sales_line_items VALUES
('T001',1,'P001',5,3000,0,15000),
('T001',2,'P004',5,6000,0,30000),
('T002',1,'P002',10,2000,0,20000),
('T002',2,'P003',1,7000,0,7000),
('T003',1,'P001',2,3000,0,6000),
('T003',2,'P005',3,15000,0,45000),
('T004',1,'P004',5,6000,0,30000),
('T004',2,'P006',1,70000,0,70000),
('T005',1,'P007',5,30000,0,150000),
('T005',2,'P008',2,22000,0,44000);
