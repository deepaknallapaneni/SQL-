-- Procedures and dynamic procedure 
-------------------------------------
-- 1.Procedures
	-- A stored procedure is a group of SQL statements stored in the database.
	-- It is precompiled and does not change dynamically.
	-- You call it with parameters, but the SQL query structure stays fixed.
-- This procedure returns all films under a specific category (like Action, Sports, Comedy).

DELIMITER $$

CREATE PROCEDURE sakila.get_films_by_category(IN cat_name VARCHAR(50))
BEGIN
    SELECT f.film_id, f.title, c.name AS category
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = cat_name;
END $$

DELIMITER ;

CALL sakila.get_films_by_category('Action');
----------------------------------------------------------------------------------
-- OUT Parameter
	-- An OUT parameter lets a stored procedure return a value to the caller.
	-- It works like a variable that gets populated inside the procedure.
-- Return the total number of films in the database

DELIMITER $$

CREATE PROCEDURE sakila.get_total_films(OUT total_films INT)
BEGIN
    SELECT COUNT(*) INTO total_films
    FROM film;
END $$

DELIMITER ;

CALL sakila.get_total_films(@x);
SELECT @x AS total_films;
----------------------------------------------------------------------------------
-- OUT Parameter With Input (IN + OUT)
-- Get number of films for a given rating (e.g., PG, R, G)

DELIMITER $$

CREATE PROCEDURE sakila.count_films_by_rating(
    IN rating_value VARCHAR(10),
    OUT film_count INT
)
BEGIN
    SELECT COUNT(*) INTO film_count
    FROM film
    WHERE rating = rating_value;
END $$

DELIMITER ;

CALL sakila.count_films_by_rating('PG', @count);
SELECT @count AS film_count;

-------------------------------------------------------------------------------------------------------------------------

-- 2. Dynamic Stored Procedure (Dynamic SQL)
	-- A dynamic stored procedure builds the SQL query inside the procedure using variables.
	-- You use PREPARE, EXECUTE, and DEALLOCATE.
-- Useful when:
	-- Table name is dynamic
	-- Column name is dynamic
	-- WHERE clause changes based on input
-- Fetch records from the film table, sorted by any column the user chooses dynamically.

DELIMITER $$

CREATE PROCEDURE sakila.get_films_sorted(IN col_name VARCHAR(50))
BEGIN
    SET @query = CONCAT('SELECT film_id, title, release_year, rating 
                         FROM film 
                         ORDER BY ', col_name, ';');

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END $$

DELIMITER ;


CALL sakila.get_films_sorted('rating');
CALL sakila.get_films_sorted('title');
CALL sakila.get_films_sorted('release_year');
