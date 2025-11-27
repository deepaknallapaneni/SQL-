-- 1. Identify if there are duplicates in Customer table. Don't use customer id to check the duplicates
SELECT first_name, last_name, email, COUNT(*) AS duplicate_count
FROM sakila.customer
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;

-- 2. Number of times letter 'a' is repeated in film descriptions
SELECT 
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'a', ''))) 
    AS total_a_count
FROM sakila.film_text;

-- 3. Number of times each vowel is repeated in film descriptions 
SELECT
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'a', ''))) AS count_a,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'e', ''))) AS count_e,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'i', ''))) AS count_i,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'o', ''))) AS count_o,
    SUM(LENGTH(description) - LENGTH(REPLACE(description, 'u', ''))) AS count_u
FROM sakila.film_text;

-- 4. Display the payments made by each customer
        -- 1. Month wise
        -- 2. Year wise
        -- 3. Week wise
-- Month wise
SELECT 
    customer_id,
    MONTH(payment_date) AS month,
    SUM(amount) AS total_payment
FROM sakila.payment
GROUP BY customer_id, month;

-- Year wise
SELECT 
    customer_id,
    YEAR(payment_date) AS year,
    SUM(amount) AS total_payment
FROM sakila.payment
GROUP BY customer_id, year;

-- week wise
SELECT 
    customer_id,
    YEAR(payment_date) AS year,
    WEEK(payment_date,1) AS week_number,
    SUM(amount) AS total_payment
FROM sakila.payment
GROUP BY customer_id, year, week_number;

select WEEK(payment_date,1) AS week_number from sakila.payment;
-- Mode 1 means: Week starts on Monday

-- 5. Check if a given year is a leap year using SELECT (hardcoded date)
SELECT 
    CASE 
        WHEN (YEAR('2025-11-26') % 400 = 0)
          OR (YEAR('2025-11-26') % 4 = 0 AND YEAR('2025-11-26') % 100 <> 0)
        THEN 'Leap Year'
        ELSE 'Not a Leap Year'
    END AS leap_year_check;
	
-- 6. Display number of days remaining in the current year from today.
SELECT 
    DATEDIFF(
        MAKEDATE(YEAR(CURDATE()), 365), 
        CURDATE()
    ) AS days_remaining;
    
-- MAKEDATE(year, day_of_year) does: It creates a date using:the year the day number in that year (1 to 365 or 366)

-- 7. Display quarter number(Q1,Q2,Q3,Q4) for the payment dates from payment table. 
SELECT 
    payment_id,
    payment_date,
    CONCAT('Q', QUARTER(payment_date)) AS quarter_number
FROM sakila.payment;

-- 8. Display the age in year, months, days based on your date of birth. 
   -- For example: 21 years, 4 months, 12 days
   
SELECT
    CONCAT(
        TIMESTAMPDIFF(YEAR, '2002-03-13', CURDATE()), ' years, ',
        TIMESTAMPDIFF(MONTH, '2002-03-13', CURDATE()) 
            - (TIMESTAMPDIFF(YEAR, '2002-03-13', CURDATE()) * 12), ' months, ',
        DAY(
            CURDATE() - INTERVAL 
                TIMESTAMPDIFF(MONTH, '2002-03-13', CURDATE()) MONTH
        ), ' days'
    ) AS age;
