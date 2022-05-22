 --                               Chapter 1: Use Real-World SQL


        --Review the essentials

--In this exercise you must prepare the data you need (title & description) to run a promotion for the store's Italian & French language films from 2005.

--1 Return the title and description from the film table. Make sure to alias this table AS f.

SELECT title, description
FROM film AS f

--2 Use an INNER JOIN to bring in language data about your films using the language_id as the join column.

SELECT title, description
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
  
--3 Use the IN command to limit the results where the language name is either Italian or French.
--Ensure only the release_year of the films is 2005.

SELECT title, description
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
WHERE l.name IN ('Italian','French')
  AND f.release_year = 2005 ;
  
  
                         --Practice the essentials

--In this exercise you are preparing list of your top paying active customers. The data you will need are the names of the customer sorted by the amount they paid.

--Return the first_name, last_name and amount.
--INNER JOIN the tables you need for this query: payment and customer using the customer_id for the join.
--Ensure only active customers are returned.
--Sort the results in DESCending order by the amount paid.

SELECT c.first_name,
	     c.last_name,
       p.amount
FROM payment AS p
INNER JOIN customer AS c
  ON p.customer_id = c.customer_id
WHERE c.active='true'
ORDER BY p.amount desc;


                           --Transform numeric & strings

--For this exercise you are planning to run a 50% off promotion for films released prior to 2006. To prepare for this promotion you will need to return the films
--that qualify for this promotion, to make these titles easier to read you will convert them all to lower case. You will also need to return both the original_rate 
--and the sale_rate.

--Return the LOWER-case titles of the films.
--Return the original rental_rate and the 50% discounted sale_rate by multiplying rental_rate by 0.5.
--Ensure only films prior to 2006 are considered for this promotion.

SELECT lower(title) AS title, 
  rental_rate  AS original_rate, 
  rental_rate * 0.5 AS sale_rate 
FROM film
where release_year<2006;

                           --Extract what you need

--In this exercise you will practice preparing date/time elements by using the EXTRACT() function.

--1 EXTRACT the DAY from payment_date and return this column AS the payment_day.

SELECT payment_date,
  EXTRACT(DAY from payment_date) AS payment_day 
FROM payment;

--2 EXTRACT the YEAR from payment_date and return this column AS the payment_year.

SELECT payment_date,
  EXTRACT(YEAR from payment_date) AS payment_year 
FROM payment;

--3 EXTRACT the HOUR from payment_date and return this column AS the payment_hour.

SELECT payment_date,
  EXTRACT(hour from payment_date) AS payment_hour 
FROM payment;

                           --




