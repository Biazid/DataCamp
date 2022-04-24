--Which table has the most rows? Which table has the most columns?
--stackoverflow has the most rows; fortune500 has the most columns

--First, figure out how many rows are in fortune500 by counting them.
-- Select the count of the number of rows
SELECT count(*)
  FROM fortune500;
  
-- Subtract the count of the non-NULL ticker values from the total number of rows; alias the difference as missing.
-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - count(ticker) AS missing
  FROM fortune500;
  
 -- Repeat for the profits_change column.
-- Select the count of profits_change, 
-- subtract from total number of rows, and alias as missing
select count(profits_change)
from fortune500;

select count(*)- count(profits_change) as missing
from fortune500

-- Repeat for the industry column.
-- Select the count of industry, 
-- subtract from total number of rows, and alias as missing
select count(industry)
from fortune500;

select count(*)- count(industry) as missing
from fortune500

--Look at the contents of the company and fortune500 tables. Find a column that they have in common where the values for each company are the same in both tables.
--Join the company and fortune500 tables with an INNER JOIN.
--Select only company.name for companies that appear in both tables.

-- SELECT company.name
-- Table(s) to select from
  FROM company
       INNER JOIN  fortune500 ON
      company.ticker=fortune500.ticker;

-- Recall that foreign keys reference another row in the database via a unique ID. Values in a foreign key column are restricted to values in the referenced column OR NULL.
--Using what you know about foreign keys, why can't the tag column in the tag_type table be a foreign key that references the tag column in the stackoverflow table?
--Remember, you can reference the slides using the icon in the upper right of the screen to review the requirements for a foreign key.
-- Ans: stackoverflow.tag contains duplicate values


-- First, using the tag_type table, count the number of tags with each type.
--Order the results to find the most common tag type.
-- Count the number of tags with each type
SELECT type, count(tag) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
 GROUP BY type 
 -- Order the results with the most common
 -- tag types listed first
 ORDER BY count desc;
 
 -- Join the tag_company, company, and tag_type tables, keeping only mutually occurring records.
-- Select company.name, tag_type.tag, and tag_type.type for tags with the most common type from the previous step.
-- Select the 3 columns desired
SELECT company.name, tag_type.tag, tag_type.type
  FROM company
  	   -- Join to the tag_company table
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       -- Join to the tag_type table
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';
  
  -- Use coalesce() to select the first non-NULL value from industry, sector, or 'Unknown' as a fallback value.
-- Alias the result of the call to coalesce() as industry2.
-- Count the number of rows with each industry2 value.
-- Find the most common value of industry2.
-- Use coalesce
SELECT coalesce(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       count(industry) 
  FROM fortune500 
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
ORDER BY count(industry) desc
-- Limit results to get just the one value you want
limit 1

-- Coalesce with a self-join
-- Join company to itself to add information about a company's parent to the original company's information.
--Use coalesce to get the parent company ticker if available and the original company ticker otherwise.
--INNER JOIN to fortune500 using the ticker.
--Select original company name, fortune500 title and rank.

SELECT company_original.name, title, rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id = company_parent.id 
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_parent.ticker, 
                   company_original.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank; 
 
 
--Effects of casting
--Select profits_change and profits_change cast as integer from fortune500.
--Look at how the values were converted.
-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change as integer) AS profits_change_int
  FROM fortune500;

--Compare the results of casting of dividing the integer value 10 by 3 to the result of dividing the numeric value 10 by 3.
-- Divide 10 by 3
SELECT 10/3, 
       -- Cast 10 as numeric and divide by 3
       10::numeric  /3;
    
--Now cast numbers that appear as text as numeric. Note: 1e3 is scientific notation.
SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;
       
--Summarize the distribution of numeric values
--Use GROUP BY and count() to examine the values of revenues_change.
--Order the results by revenues_change to see the distribution.
-- Select the count of each value of revenues_change
SELECT revenues_change,count(revenues_change)
  FROM fortune500
Group by revenues_change
 -- order by the values of revenues_change
 ORDER BY revenues_change;
 
--Repeat step 1, but this time, cast revenues_change as an integer to reduce the number of different values.
-- Select the count of each revenues_change integer value
SELECT revenues_change::integer, count(revenues_change)
  FROM fortune500
 group by  revenues_change::integer
 -- order by the values of revenues_change
 ORDER BY revenues_change;
 
 --How many of the Fortune 500 companies had revenues increase in 2017 compared to 2016? 
 --To find out, count the rows of fortune500 where revenues_change indicates an increase.
 -- Count rows 
SELECT count(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change > 0;
 
 
 
 
 --							Chapter 2: Summarizing and aggregating numeric data

























