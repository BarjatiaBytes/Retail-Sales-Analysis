---------------------------------------------------------------------------------------
-- Index Creation 
---------------------------------------------------------------------------------------

--1. Indexes on Foriegn Keys in the largest table (sales)

CREATE INDEX idx_sales_customer_id ON sales (customer_id);
CREATE INDEX idx_sales_product_id ON sales(product_id);
CREATE INDEX idx_sales_person_id ON sales(sales_person_id);


--2. Index on Time based filtering
CREATE INDEX idx_sales_date ON sales (sales_date);


--3. Indexing Foriegn Keys
CREATE INDEX idx_customer_city_id ON  customer (city_id);
CREATE INDEX idx_employees_city_id ON employees (city_id);
CREATE INDEX idx_product_category_id ON product (category_id);


---------------------------------------------------------------------------------------
-- EDA (Exploratory Data Analaysis)
---------------------------------------------------------------------------------------

-- Table Structure & Row Samples
SELECT * FROM product;

SELECT * FROM country;

SELECT * FROM city;

SELECT * FROM category;

SELECT * FROM employees;

SELECT * FROM customer;

SELECT * FROM sales
LIMIT 100;




-- Category Product Counts
SELECT
	category_name,
	COUNT(*)
FROM 
	category as c
JOIN product as p
ON c.category_id = p.category_id
GROUP BY 1;



-- Product Tier Counts
SELECT 
	product_tier, COUNT(*)
FROM product
GROUP BY 1;



-- Product Price Distribution
SELECT
	MIN(price),
	MAX(price),
	ROUND(AVG(price),2)
FROM product;



-- Average Quantity Sold
SELECT ROUND(AVG(quantity),2)
	FROM sales;


-- Date Range
SELECT
    MIN(sales_date) AS start_date,
    MAX(sales_date) AS end_date,
    AGE(MAX(sales_date), MIN(sales_date)) AS duration
FROM
    sales;
	


-- Quantity Variance & Stdev
SELECT 
	ROUND(VAR_SAMP(quantity),2) AS variance_qty,
	ROUND(STDDEV_SAMP(quantity),2) AS stdev_qty -- there is a reasonable spread
FROM sales;



--Quantity by Discount Status
SELECT 
	CASE 
		WHEN discount > 0 THEN 'Discount'
		ELSE 'No Discount'
	END AS discount_cat,
	ROUND(AVG(quantity),2) AS average_quantity_sold
FROM sales
GROUP BY discount_cat;



---------------------------------------------------------------------------------------
-- Numerical Outliers of diffrent tables
---------------------------------------------------------------------------------------


-- Top Discount Outliers
SELECT
    s.sale_id,
    p.product_name,
    s.discount
FROM
    sales AS s
JOIN
    product AS p ON s.product_id = p.product_id
ORDER BY
    s.discount DESC
LIMIT 10;



-- Monthly Sales Volume
SELECT
    TO_CHAR(sales_date, 'YYYY') AS sale_year,     -- Extracts the four-digit year 
    TO_CHAR(sales_date, 'MM') AS sale_month_num, -- Extracts the two-digit month 
    COUNT(sale_id) AS monthly_sales_count
FROM
    sales
GROUP BY
    1,
    2
ORDER BY
   1,
   2;


---------------------------------------------------------------------------------------
-- Finacial Performance & Discount Analysis (KPIs)
---------------------------------------------------------------------------------------

-- Discount Tier Profitability
SELECT
    s.discount,
    COUNT(s.transaction_number) AS total_transactions,
    ROUND(SUM(s.total_price), 2) AS total_revenue,
    ROUND(SUM(s.total_price) / COUNT(s.transaction_number), 2) AS average_order_value_aov
FROM
    sales AS s
WHERE
    s.discount > 0.00 
GROUP BY
    s.discount
ORDER BY
    s.discount DESC;



-- 20% Discount by Category
SELECT
    c.category_id,
    c.category_name,
    COUNT(s.sale_id) AS total_sales_at_20_percent_discount
FROM
    sales AS s
JOIN
    product AS p ON s.product_id = p.product_id
JOIN
    category AS c ON p.category_id = c.category_id
WHERE
    s.discount = 0.20 
GROUP BY
    c.category_id,
    c.category_name 
ORDER BY
    3 DESC;


	
-- Geographical Revenue Ranking
SELECT
    ci.city_name,
    COUNT(s.sale_id) AS total_transactions,
    ROUND(SUM(s.total_price), 2) AS total_net_revenue,
    RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS revenue_rank
FROM
    sales AS s
JOIN
    customer AS cu ON s.customer_id = cu.customer_id
JOIN
    city AS ci ON cu.city_id = ci.city_id
GROUP BY
    1
ORDER BY
    3 DESC
LIMIT 10;


-- Category Discount AOV
SELECT
    c.category_name,
    s.discount,
    COUNT(s.sale_id) AS total_transactions,
    ROUND(SUM(s.total_price) / COUNT(s.transaction_number), 2) AS category_aov
FROM
    sales AS s
JOIN
    product AS p ON s.product_id = p.product_id
JOIN
    category AS c ON p.category_id = c.category_id
WHERE
    s.discount IN (0.10, 0.20)
GROUP BY
    c.category_name,
    s.discount
ORDER BY
    c.category_name,
    s.discount DESC;



-- Discount Adoption by City (10%)
WITH CityTransactions AS (
    --Discount Adoption Rate by Top City
    SELECT
        ci.city_name,
        COUNT(s.sale_id) AS total_transactions,
        SUM(CASE WHEN s.discount = 0.10 THEN 1 ELSE 0 END) AS ten_percent_discount_transactions
    FROM
        sales AS s
    JOIN
        customer AS cu ON s.customer_id = cu.customer_id
    JOIN
        city AS ci ON cu.city_id = ci.city_id
    WHERE
        ci.city_name IN ('Tucson', 'Jackson', 'Sacramento', 'Fort Wayne', 'Indianapolis', 'Columbus', 'Charlotte', 'San Antonio')
    GROUP BY
        ci.city_name
)
SELECT
    city_name,
    total_transactions,
    ten_percent_discount_transactions,
    ROUND(
        (ten_percent_discount_transactions * 100.0) / total_transactions,
        2
    ) AS discount_adoption_rate_percent
FROM
    CityTransactions
ORDER BY
    discount_adoption_rate_percent DESC;



-- Monthly Average Order Value
SELECT
    -- Truncating date to the start of the month for grouping
    DATE_TRUNC('month', sales_date) AS sales_month,
    COUNT(DISTINCT transaction_number) AS total_transactions,
    ROUND(SUM(total_price) / COUNT(DISTINCT transaction_number), 2) AS monthly_aov
FROM
    sales
GROUP BY
    1
ORDER BY
    1;


---------------------------------------------------------------------------------------
-- Product & Category Health
---------------------------------------------------------------------------------------

-- Product Tier Revenue 
SELECT
    p.product_tier,
    COUNT(s.sale_id) AS total_transactions,
    SUM(s.quantity) AS total_units_sold,
    ROUND(SUM(s.total_price), 2) AS total_revenue
FROM
    sales AS s
JOIN
    product AS p ON s.product_id = p.product_id
WHERE
    p.product_tier IS NOT NULL 
GROUP BY
    p.product_tier
ORDER BY
    total_revenue DESC;



-- Category Volume Popularity
SELECT
    c.category_name,
    SUM(s.quantity) AS total_units_sold
FROM
    sales AS s
JOIN
    product AS p ON s.product_id = p.product_id
JOIN
    category AS c ON p.category_id = c.category_id
GROUP BY
    c.category_name
ORDER BY
    total_units_sold DESC;



-- Product Revenue Ranking
SELECT
    p.product_name,
    ROUND(SUM(s.total_price), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS revenue_rank
FROM
    sales AS s
JOIN
    product AS p ON s.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    total_revenue DESC
LIMIT 10;



---------------------------------------------------------------------------------------
-- Sales Efficiency & Employee Performance
---------------------------------------------------------------------------------------

--Employee Revenue Leaderboard
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    COUNT(s.sale_id) AS total_sales_transactions,
    ROUND(SUM(s.total_price), 2) AS total_revenue_generated,
    RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS revenue_rank
FROM
    sales AS s
JOIN
    employees AS e ON s.sales_person_id = e.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name
ORDER BY
    total_revenue_generated DESC
LIMIT 10;


-- High Quantity Transactions
SELECT
    s.sales_person_id,
    e.first_name || ' ' || e.last_name AS employee_full_name,
    s.quantity
FROM
    sales AS s
JOIN
    employees AS e ON s.sales_person_id = e.employee_id
WHERE
    s.quantity > (
        SELECT AVG(quantity)
        FROM SALES
    )
ORDER BY
    s.quantity DESC;


	
-- Employee Transaction Count
SELECT
    e.first_name || ' ' || e.last_name AS salesperson_name,
    COUNT(s.sale_id) AS total_sales_transactions
FROM
    employees AS e
JOIN
    sales AS s ON e.employee_id = s.sales_person_id
GROUP BY
    1
ORDER BY
    total_sales_transactions DESC;



-- City Quantity per Transaction
SELECT 
	city_name, COUNT(*) as n_transactions,
	ROUND(AVG(quantity),2)AS avg_qty
	FROM (
			SELECT s.quantity, c.city_name
			FROM sales AS s
			LEFT JOIN employees AS e 
			ON s.sales_person_id = e.employee_id
			LEFT JOIN
				city AS c 
			ON 
				e.city_id = c.city_id
				)
GROUP BY 1
ORDER BY 3 DESC;
