--
-- PostgreSQL database dump
--

SET client_encoding = 'LATIN1';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: new_customer(character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: chriskl
--

CREATE FUNCTION new_customer(firstname_in character varying, lastname_in character varying, address1_in character varying, address2_in character varying, city_in character varying, state_in character varying, zip_in integer, country_in character varying, region_in integer, email_in character varying, phone_in character varying, creditcardtype_in integer, creditcard_in character varying, creditcardexpiration_in character varying, username_in character varying, password_in character varying, age_in integer, income_in integer, gender_in character varying, OUT customerid_out integer) RETURNS integer
    AS '
  DECLARE
    rows_returned INT;
  BEGIN
    SELECT COUNT(*) INTO rows_returned FROM CUSTOMERS WHERE USERNAME = username_in;
    IF rows_returned = 0 THEN
	    INSERT INTO CUSTOMERS
	      (
	      FIRSTNAME,
	      LASTNAME,
	      EMAIL,
	      PHONE,
	      USERNAME,
	      PASSWORD,
	      ADDRESS1,
	      ADDRESS2,
	      CITY,
	      STATE,
	      ZIP,
	      COUNTRY,
	      REGION,
	      CREDITCARDTYPE,
	      CREDITCARD,
	      CREDITCARDEXPIRATION,
	      AGE,
	      INCOME,
	      GENDER
	      )
	    VALUES
	      (
	      firstname_in,
	      lastname_in,
	      email_in,
	      phone_in,
	      username_in,
	      password_in,
	      address1_in,
	      address2_in,
	      city_in,
	      state_in,
	      zip_in,
	      country_in,
	      region_in,
	      creditcardtype_in,
	      creditcard_in,
	      creditcardexpiration_in,
	      age_in,
	      income_in,
	      gender_in
	      )
	     ;
    select currval(pg_get_serial_sequence(''customers'', ''customerid'')) into customerid_out;
  ELSE
  	customerid_out := 0;
  END IF;
END
'
    LANGUAGE plpgsql;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE categories (
    category serial NOT NULL,
    categoryname character varying(50) NOT NULL
);


--
-- Name: categories_category_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('categories', 'category'), 16, true);


--
-- Name: cust_hist; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE cust_hist (
    customerid integer NOT NULL,
    orderid integer NOT NULL,
    prod_id integer NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE customers (
    customerid serial NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    address1 character varying(50) NOT NULL,
    address2 character varying(50),
    city character varying(50) NOT NULL,
    state character varying(50),
    zip integer,
    country character varying(50) NOT NULL,
    region smallint NOT NULL,
    email character varying(50),
    phone character varying(50),
    creditcardtype integer NOT NULL,
    creditcard character varying(50) NOT NULL,
    creditcardexpiration character varying(50) NOT NULL,
    username character varying(50) NOT NULL,
    "password" character varying(50) NOT NULL,
    age smallint,
    income integer,
    gender character varying(1)
);


--
-- Name: customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('customers', 'customerid'), 20000, true);


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE inventory (
    prod_id integer NOT NULL,
    quan_in_stock integer NOT NULL,
    sales integer NOT NULL
);


--
-- Name: orderlines; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE orderlines (
    orderlineid integer NOT NULL,
    orderid integer NOT NULL,
    prod_id integer NOT NULL,
    quantity smallint NOT NULL,
    orderdate date NOT NULL
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE orders (
    orderid serial NOT NULL,
    orderdate date NOT NULL,
    customerid integer,
    netamount numeric(12,2) NOT NULL,
    tax numeric(12,2) NOT NULL,
    totalamount numeric(12,2) NOT NULL
);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('orders', 'orderid'), 12000, true);


--
-- Name: products; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE products (
    prod_id serial NOT NULL,
    category integer NOT NULL,
    title character varying(50) NOT NULL,
    actor character varying(50) NOT NULL,
    price numeric(12,2) NOT NULL,
    special smallint,
    common_prod_id integer NOT NULL
);


--
-- Name: products_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('products', 'prod_id'), 10000, true);


--
-- Name: reorder; Type: TABLE; Schema: public; Owner: chriskl; Tablespace:
--

CREATE TABLE reorder (
    prod_id integer NOT NULL,
    date_low date NOT NULL,
    quan_low integer NOT NULL,
    date_reordered date,
    quan_reordered integer,
    date_expected date
);



-- Insert random data into the categories table
INSERT INTO categories (categoryname)
SELECT 'Category ' || generate_series(1, 1000); -- Generate 10 random category names

-- Insert random data into the customers table using the new_customer function
INSERT INTO customers (firstname, lastname, email, phone, username, password, address1, address2, city, state, zip, country, region, creditcardtype, creditcard, creditcardexpiration, age, income, gender)
SELECT
    md5(random()::text), -- Random firstname
    md5(random()::text), -- Random lastname
    md5(random()::text) || '@example.com', -- Random email
    '555-' || floor(random() * 900 + 100) || '-' || floor(random() * 9000 + 1000), -- Random phone
    'user_' || floor(random() * 10000), -- Random username
    md5(random()::text), -- Random password
    floor(random() * 999) || ' Random St',
    CASE WHEN random() < 0.5 THEN NULL ELSE floor(random() * 99) || ' Apt ' || floor(random() * 10) END,
    (ARRAY['Anytown', 'Springfield', 'Hill Valley', 'Gotham', 'Metropolis'])[floor(random() * 5) + 1],
    (ARRAY['CA', 'IL', 'NY', 'TX', 'FL'])[floor(random() * 5) + 1],
    floor(random() * 90000 + 10000), -- Random zip
    'USA',
    floor(random() * 5) + 1, -- Random region
    floor(random() * 3) + 1, -- Random creditcardtype
    md5(random()::text), -- Random creditcard
    floor(random() * 12 + 1) || '/' || (CURRENT_DATE + interval '1 year')::varchar(4), -- Random expiration
    floor(random() * 60 + 18), -- Random age
    floor(random() * 100000), -- Random income
    (ARRAY['M', 'F'])[floor(random() * 2) + 1] -- Random gender
FROM generate_series(1, 500000); -- Insert 50 random customers directly (bypassing the function for bulk insert)

select * from customers;

-- Insert random data into the orders table
INSERT INTO orders (orderdate, customerid, netamount, tax, totalamount)
SELECT
    (CURRENT_DATE - (random() * 365 * interval '1 day'))::date, -- Random order date within the last year
    (SELECT customerid FROM customers ORDER BY RANDOM() LIMIT 1), -- Random customer
    round((random() * 500)::numeric, 2), -- Random net amount - Corrected line
    round((random() * 50)::numeric, 2), -- Random tax - Corrected line
    round((random() * 550)::numeric, 2)  -- Random total amount - Corrected line
FROM generate_series(1, 20000000); -- Insert 200 random orders

-- select * from orders;

-- Insert random data into the products table
-- Insert random data into the products table
INSERT INTO products (category, title, actor, price, special, common_prod_id)
SELECT
    (SELECT category FROM categories ORDER BY RANDOM() LIMIT 1), -- Random category
    'Product ' || md5(random()::text), -- Random title
    'Actor ' || md5(random()::text), -- Random actor
    round((random() * 100 + 5)::numeric, 2), -- Random price - Corrected line
    CASE WHEN random() < 0.2 THEN floor(random() * 5) + 1 ELSE NULL END, -- Random special (nullable)
    floor(random() * 1000) + 1 -- Random common_prod_id
FROM generate_series(1, 100000); -- Insert 100 random products


-- Create a sequence for orderlineid if it doesn't exist
CREATE SEQUENCE IF NOT EXISTS orderlines_orderlineid_seq;

-- Insert random data into the orderlines table with sequential orderlineid
INSERT INTO orderlines (orderlineid, orderid, prod_id, quantity, orderdate)
SELECT
    nextval('orderlines_orderlineid_seq'), -- Get the next value from the sequence
    (SELECT orderid FROM orders ORDER BY RANDOM() LIMIT 1),
    (SELECT prod_id FROM products ORDER BY RANDOM() LIMIT 1),
    floor(random() * 5) + 1,
    (SELECT orderdate FROM orders ORDER BY RANDOM() LIMIT 1)
FROM generate_series(1, 5000000);

-- delete from orderlines;

-- Insert random data into the inventory table
INSERT INTO inventory (prod_id, quan_in_stock, sales)
SELECT
    (SELECT prod_id FROM products ORDER BY RANDOM() LIMIT 1), -- Random product
    floor(random() * 200), -- Random quantity in stock
    floor(random() * 1000) -- Random sales count
FROM generate_series(1, 1000000); -- Insert 100 random inventory records

-- Insert random data into the cust_hist table
INSERT INTO cust_hist (customerid, orderid, prod_id)
SELECT
    (SELECT customerid FROM customers ORDER BY RANDOM() LIMIT 1), -- Random customer
    (SELECT orderid FROM orders ORDER BY RANDOM() LIMIT 1), -- Random order
    (SELECT prod_id FROM products ORDER BY RANDOM() LIMIT 1) -- Random product
FROM generate_series(1, 10000000); -- Insert 1000 random customer history records

select * from cust_hist;

-- Insert random data into the reorder table
INSERT INTO reorder (prod_id, date_low, quan_low, date_reordered, quan_reordered, date_expected)
SELECT
    (SELECT prod_id FROM products ORDER BY RANDOM() LIMIT 1), -- Random product
    (CURRENT_DATE - (random() * 180 * interval '1 day'))::date, -- Random date low
    floor(random() * 20) + 5, -- Random quantity low
    CASE WHEN random() < 0.7 THEN (CURRENT_DATE - (random() * 90 * interval '1 day'))::date ELSE NULL END, -- Random reordered date (nullable)
    CASE WHEN random() < 0.7 THEN floor(random() * 50) + 10 ELSE NULL END, -- Random quantity reordered (nullable)
    CASE WHEN random() < 0.7 THEN (CURRENT_DATE + (random() * 90 * interval '1 day'))::date ELSE NULL END -- Random expected date (nullable)
FROM generate_series(1, 500000); -- Insert 50 random reorder records

-- Complex Query 1: Find customers who placed orders for Electronics products
-- Joining customers, orders, orderlines, and products on non-indexed columns (potentially)
SELECT
    c.firstname,
    c.lastname,
    c.email,
    o.orderid,
    o.orderdate,
    p.title AS product_title,
    cat.categoryname
FROM
    customers c
JOIN
    orders o ON c.customerid = o.customerid
JOIN
    orderlines ol ON o.orderid = ol.orderid
JOIN
    products p ON ol.prod_id = p.prod_id
JOIN
    categories cat ON p.category = cat.category
WHERE
    cat.categoryname = 'Electronics';

-- Complex Query 2: List products that have never been reordered
-- Joining products and reorder on prod_id (likely indexed, but we'll assume for the exercise)
SELECT
    p.title AS product_title,
    p.price
FROM
    products p
LEFT JOIN
    reorder r ON p.prod_id = r.prod_id
WHERE
    r.prod_id IS NULL;

-- Complex Query 3: Find the average quantity of each product ordered by customers in a specific region
-- Joining customers, orders, orderlines, and products on non-indexed columns (potentially)
SELECT
    p.title AS product_title,
    c.country,
    AVG(ol.quantity) AS average_quantity
FROM
    customers c
JOIN
    orders o ON c.customerid = o.customerid
JOIN
    orderlines ol ON o.orderid = ol.orderid
JOIN
    products p ON ol.prod_id = p.prod_id
WHERE
    c.region = 2 -- Assuming region 2 is a specific region
GROUP BY
    p.title, c.country
ORDER BY
    p.title;

-- Complex Query 4: Show customers and the last product category they ordered from
-- Using subqueries and joins on non-indexed columns (potentially)
SELECT
    c.firstname,
    c.lastname,
    (
        SELECT
            cat.categoryname
        FROM
            orders o2
        JOIN
            orderlines ol2 ON o2.orderid = ol2.orderid
        JOIN
            products p2 ON ol2.prod_id = p2.prod_id
        JOIN
            categories cat ON p2.category = cat.category
        WHERE
            o2.customerid = c.customerid
        ORDER BY
            o2.orderdate DESC
        LIMIT 1
    ) AS last_ordered_category
FROM
    customers c;

-- Complex Query 5: Find products that have a lower than average quantity in stock across all inventory
-- Joining products and inventory on prod_id (likely indexed, but we'll assume)
SELECT
    p.title AS product_title,
    i.quan_in_stock
FROM
    products p
JOIN
    inventory i ON p.prod_id = i.prod_id
WHERE
    i.quan_in_stock < (SELECT AVG(quan_in_stock) FROM inventory);

-- Complex Query 6: List customers who have placed more than a certain number of orders
-- Joining customers and orders on non-indexed columns (potentially)
SELECT
    c.firstname,
    c.lastname,
    COUNT(o.orderid) AS total_orders
FROM
    customers c
JOIN
    orders o ON c.customerid = o.customerid
GROUP BY
    c.customerid, c.firstname, c.lastname
HAVING
    COUNT(o.orderid) > 2; -- Customers with more than 2 orders

-- Complex Query 7: Find products that were ordered on the same date as a product from a specific category
-- Joining orders, orderlines, and products on non-indexed columns (potentially)
SELECT DISTINCT
    p1.title AS product1_title,
    p1.category AS product1_category,
    o1.orderdate
FROM
    orders o1
JOIN
    orderlines ol1 ON o1.orderid = ol1.orderid
JOIN
    products p1 ON ol1.prod_id = p1.prod_id
WHERE EXISTS (
    SELECT 1
    FROM orders o2
    JOIN orderlines ol2 ON o2.orderid = ol2.orderid
    JOIN products p2 ON ol2.prod_id = p2.prod_id
    JOIN categories cat ON p2.category = cat.category
    WHERE o1.orderdate = o2.orderdate
      AND cat.categoryname = 'Books' -- Example specific category
);
