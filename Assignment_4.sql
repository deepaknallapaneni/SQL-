-- Assignment - 4 

-- 1. List all customers along with the films they have rented.
select sc.customer_id, sc.first_name, sc.last_name, sf.title from sakila.customer sc join sakila.inventory using(store_id)
join sakila.film sf using(film_id);

-- 2. List all customers and show their rental count, including those who haven't rented any films.
select sc.customer_id, sc.first_name, sc.last_name, count(sr.rental_id) from sakila.customer sc 
left join sakila.rental sr using(customer_id) group by sc.customer_id, sc.first_name, sc.last_name;

-- 3. Show all films along with their category. Include films that don't have a category assigned.
select sf.film_id, sf.title, sc.name from sakila.film sf left join sakila.film_category sfc using (film_id) left join sakila.category sc using(category_id);

-- 4. Show all customers and staff emails from both customer and staff tables using a full outer join (simulate using LEFT + RIGHT + UNION).
select sc.customer_id, sc.email, ss.staff_id, ss.email from sakila.customer sc left join sakila.staff ss using(email) union
select sc.customer_id, sc.email, ss.staff_id, ss.email from sakila.customer sc right join sakila.staff ss using(email);

-- 5. Find all actors who acted in the film "ACADEMY DINOSAUR".
select sa.actor_id, sa.first_name, sa.last_name, sf.title from sakila.actor sa join sakila.film_actor sfa using (actor_id)
join sakila.film sf  using(film_id) where sf.title = "ACADEMY DINOSAUR";

-- 6. List all stores and the total number of staff members working in each store, even if a store has no staff.
select ss.store_id , count(sst.staff_id) as staff_members from sakila.store ss left join sakila.staff sst using(store_id) group by ss.store_id;

-- 7. List the customers who have rented films more than 5 times. Include their name and total rental count.
Select sc.customer_id, sc.first_name, sc.last_name, count(sr.rental_id) as rental_count from sakila.customer sc 
join sakila.rental sr using(customer_id) group by sc.customer_id, sc.first_name, sc.last_name having rental_count>5;