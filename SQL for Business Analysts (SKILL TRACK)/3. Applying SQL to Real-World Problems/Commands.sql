 --                               Chapter 1: Use Real-World SQL


        --Review the essentials

--In this exercise you must prepare the data you need (title & description) to run a promotion for the store's Italian & French language films from 2005.

--1 Return the title and description from the film table. Make sure to alias this table AS f.

SELECT title, description
FROM film AS f

--2 Use an INNER JOIN to bring in language data about your films using the language_id as the join column.

