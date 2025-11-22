-- Creating tables

-- Countries table
CREATE TABLE country (
    country_id INT PRIMARY KEY,            
	country_name VARCHAR(25) NOT NULL,    
    country_code CHAR(2) NOT NULL
);


-- City table
CREATE TABLE city (
	city_id INT PRIMARY KEY,
	city_name VARCHAR(50) NOT NULL,
	zip_code VARCHAR(10) NOT NULL,
	country_id INT NOT NULL,

	CONSTRAINT fk_city_country
		FOREIGN KEY (country_id)
		REFERENCES country (country_id)
);


-- Customer table
CREATE TABLE customer(
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	middle_intial CHAR(1),
	last_name VARCHAR(50) NOT NULL,
	city_id INT NOT NULL,
	address VARCHAR(255) NOT NULL,

	CONSTRAINT fk_customer_city
		FOREIGN KEY (city_id)
		REFERENCES city (city_id)
);


-- Employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_initial CHAR(1),
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    age INT,
    gender CHAR(1),
    city_id INT NOT NULL,
    hire_date DATE NOT NULL,

    CONSTRAINT fk_employee_city
        FOREIGN KEY (city_id)
        REFERENCES city (city_id)
);


-- category table
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- products table
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,
    product_tier VARCHAR(20),
    modify_date DATE,
    resistance VARCHAR(20),
    is_allergic VARCHAR(20),
    vitality_days INT,
    
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES category (category_id)
);

-- sales table
CREATE TABLE sales (
	sale_id INT PRIMARY KEY,
	sales_person_id INT NOT NULL,
	customer_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	
    -- Financial columns
	product_price DECIMAL(10, 2) NOT NULL, -- Price of the single product unit
	gross_price DECIMAL(10, 2) NOT NULL,   -- Total price before discount
	discount DECIMAL(4, 2) NOT NULL,      -- Discount rate
	net_price DECIMAL(12, 2) NOT NULL,    -- Final price after discount
	
    -- Time and Transaction details
	sales_date DATE NOT NULL,
	transaction_number VARCHAR(50),

    -- Foreign Key Constraints
	CONSTRAINT fk_sales_customer
		FOREIGN KEY(customer_id)
		REFERENCES customer(customer_id),

	CONSTRAINT fk_sales_product
		FOREIGN KEY(product_id)
		REFERENCES product(product_id),

	CONSTRAINT fk_sales_employee
		FOREIGN KEY(sales_person_id)
		REFERENCES employees (employee_id)
);