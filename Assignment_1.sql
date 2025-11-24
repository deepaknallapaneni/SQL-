-- Assignment-1


-- 1. Get all customers whose first name starts with 'J' and who are active.
select * from sakila.customer where first_name like 'J%' and active=1;

-- 2. Find all films where the title contains the word 'ACTION' or the description contains 'WAR'.
select * from sakila.film where title like '%ACTION%' or description like '%WAR%';

-- 3. List all customers whose last name is not 'SMITH' and whose first name ends with 'a'.
select count(*) from sakila.customer where last_name!= 'SMITH' and first_name like '%a';

-- 4. Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.
select * from sakila.film  where rental_rate>3.0 and replacement_cost is not NULL;

-- 5. Count how many customers exist in each store who have active status = 1.
select store_id, count(*) as totalcustomers  from sakila.customer where active=1 group by store_id;

-- 6. Show distinct film ratings available in the film table.
select distinct rating from sakila.film;

-- 7. Find the number of films for each rental duration where the average length is more than 100 minutes.
select rental_duration, count(*) as film_count, AVG(length) as avg_length from sakila.film group by rental_duration having avg(length)>100;

-- 8. List payment dates and total amount paid per date, but only include days where more than 100 payments were made.
select DATE(payment_date) as paydate, SUM(amount), count(*) as totalcount from sakila.payment group by DATE(payment_date) having count(*) >100 order by paydate;

-- 9. Find customers whose email address is null or ends with '.org'.
select * from sakila.customer where email is NULL or email  like '%.org';


-- 10. List all films with rating 'PG' or 'G', and order them by rental rate in descending order.
select * from sakila.film where rating IN ('PG','G') order  by rental_rate DESC;


-- 11. Count how many films exist for each length where the film title starts with 'T' and the count is more than 5.

SELECT length, COUNT(*) AS film_count
FROM sakila.film
WHERE title LIKE 'T%'          
GROUP BY length                
HAVING COUNT(*) > 5;

-- 0 rows returned so they are no films that film starts with 'T' and count more than 5

-- 12. List all actors who have appeared in more than 10 films.

SELECT act.actor_id, act.first_name, act.last_name, COUNT(*) AS filmcount FROM sakila.actor as act
	JOIN sakila.film_actor as filmact ON filmact.actor_id = act.actor_id
	GROUP BY act.actor_id, act.first_name, act.last_name
	HAVING COUNT(*) > 10;

-- 13. Find the top 5 films with the highest rental rates and longest lengths combined, ordering by rental rate first and length second.
SELECT film_id, title, rental_rate, length FROM sakila.film ORDER BY rental_rate DESC, length DESC LIMIT 5;

-- 14. Show all customers along with the total number of rentals they have made, ordered from most to least rentals.
SELECT sc.customer_id, sc.first_name, sc.last_name, COUNT(sr.rental_id) AS totalrentals FROM sakila.customer as sc
JOIN sakila.rental sr ON sr.customer_id = sc.customer_id
GROUP BY sc.customer_id, sc.first_name, sc.last_name
ORDER BY totalrentals DESC ;

-- 15. List the film titles that have never been rented.
select sf.film_id, sf.title
FROM sakila.film sf
WHERE NOT EXISTS (
  SELECT *
  FROM sakila.inventory si
  JOIN sakila.rental sr ON sr.inventory_id = si.inventory_id
  WHERE si.film_id = sf.film_id
);

-- 16. Find all staff members along with the total payments they have processed, ordered by total payment amount in descending order.
SELECT ss.staff_id,
       ss.first_name,
       ss.last_name,
       SUM(sp.amount) AS totalpayment
FROM sakila.staff ss
LEFT JOIN sakila.payment sp ON sp.staff_id = ss.staff_id
GROUP BY ss.staff_id, ss.first_name, ss.last_name
ORDER BY totalpayment DESC;

-- 17. Show the category name along with the total number of films in each category.
SELECT sc.category_id,
       sc.name AS category_name,
       COUNT(sfc.film_id) AS filmcount
FROM sakila.category sc
JOIN sakila.film_category sfc ON sfc.category_id = sc.category_id
GROUP BY sc.category_id, sc.name
ORDER BY filmcount DESC;

-- 18. List the top 3 customers who have spent the most money in total.
SELECT sc.customer_id,
       sc.first_name,
       sc.last_name,
       SUM(sp.amount) AS totalspent
FROM sakila.customer sc
JOIN sakila.payment sp ON sp.customer_id = sc.customer_id
GROUP BY sc.customer_id, sc.first_name, sc.last_name
ORDER BY totalspent DESC
LIMIT 3;

-- 19. Find all films that were rented in the month of May (any year) and have a rental duration greater than 5 days.
SELECT DISTINCT sf.film_id, sf.title
FROM sakila.film sf
JOIN sakila.inventory si ON si.film_id = sf.film_id
JOIN sakila.rental sr   ON sr.inventory_id = si.inventory_id
WHERE MONTH(sr.rental_date) = 5
  AND sf.rental_duration > 5;
  
-- 20. Get the average rental rate for each film category, but only include categories with more than 50 films.
SELECT sc.category_id,
       sc.name AS categoryname,
       AVG(sf.rental_rate) AS avg_rentalrate,
       COUNT(sfc.film_id)  AS filmcount
FROM sakila.category sc
JOIN sakila.film_category sfc ON sfc.category_id = sc.category_id
JOIN sakila.film sf ON sf.film_id = sfc.film_id
GROUP BY sc.category_id, sc.name
HAVING COUNT(sfc.film_id) > 50
ORDER BY avg_rentalrate DESC, sc.name;

