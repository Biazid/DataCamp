                                          	         --Chapter 1: Data Cleaning Basics

					--Developing a data cleaning mindset
/*
When is the best time to implement data cleaning processes?

Ans: As soon as possible in the data collection pipeline
*/

					--Applying functions for string cleaning
/*
Throughout this course, we will be using a dataset with 5000 New York City parking violation records stored in the parking_violation table.

A service to provide parking violation recipients with a hard copy of the violation is being re-designed. For proper formatting of the output of the information 
on the report, some fields needs to be changed from the database representation. The changes are as follows:

For proper text alignment on the form, violation_location values must be 4 characters in length.
All P-U (pick-up truck) values in the vehicle_body_type column should use a general TRK value.
Only the first letter in each word in the street_name column should be capitalized.
The LPAD(), REPLACE(), and INITCAP() functions will be used to effect these changes.
*/

--Add '0' to the beginning of any violation_location that is less than 4 digits in length using the LPAD() function.
--Replace 'P-U' with 'TRK' in values within the vehicle_body_type column using the REPLACE() function.
--Ensure that only the first letter of words in the street_name column are capitalized using the INITCAP() function.

SELECT
  -- Add 0s to ensure violation_location is 4 characters in length
  LPAD(violation_location, 4, '0') AS violation_location,
  -- Replace 'P-U' with 'TRK' in vehicle_body_type column
  REPLACE(vehicle_body_type, 'P-U', 'TRK') AS vehicle_body_type,
  -- Ensure only first letter capitalized in street_name
  INITCAP(street_name) AS street_name
FROM
  parking_violation;
  
  
  					--Classifying parking violations by time of day
/*
There have been some concerns raised that parking violations are not being issued uniformly throughout the day. 

You have been tasked with associating parking violations with the time of day of issuance. 

You determine that the simplest approach to completing this task is to create a new column named morning.

This field will be populated with (the integer) 1 if the violation was issued in the morning (between 12:00 AM and 11:59 AM),
and, (the integer) 0, otherwise. The time of issuance is recorded in the violation_time column of the parking_violation table. 

This column consists of 4 digits followed by an A (for AM) or P (for PM).

In this exercise, you will populate the morning column by matching patterns for violation_times occurring in the morning.
*/

--Use the regular expression pattern '\d\d\d\dA' in the sub-query to match violation_time values consisting of 4 consecutive digits (\d) followed by an uppercase A.
--Edit the CASE clause to populate the morning column with 1 (integer without quotes) when the regular expression is matched.
--Edit the CASE clause to populate the morning column with 0 (integer without quotes) when the regular expression is not matched.


SELECT 
	summons_number, 
    CASE WHEN 
    	summons_number IN (
          SELECT 
  			summons_number 
  		  FROM 
  			parking_violation 
  		  WHERE 
            -- Match violation_time for morning values
  			violation_time SIMILAR TO '\d\d\d\dA'
    	)
        -- Value when pattern matched
        THEN 1 
        -- Value when pattern not matched
        ELSE 0 
    END AS morning 
FROM 
	parking_violation;


					--Masking identifying information with regular expressions
/*
Regular expressions can also be used to replace patterns in strings using REGEXP_REPLACE(). The function is similar to the REPLACE() function. 
Its signature is REGEXP_REPLACE(source, pattern, replace, flags).

-pattern is the string pattern to match in the source string.
-replace is the replacement string to use in place of the pattern.
-flags is an optional string used to control matching.

For example, REGEXP_REPLACE(xyz, '\d', '_', 'g') would replace any digit character (\d) in the column xyz with an underscore (_). 
The g ("global") flag ensures every match is replaced.

To protect parking violation recipients' privacy in a new web report, all letters in the plate_id column must be replaced with a dash (-) to mask the true license 
plate number.
*/

--Use REGEXP_REPLACE() to replace all uppercase letters (A to Z) in the plate_id column with a dash character (-) so that masked license plate numbers
--can be used in the report.


SELECT 
	summons_number,
	-- Replace uppercase letters in plate_id with dash
	REGEXP_REPLACE(plate_id, '[A-Z]', '-', 'g') 
FROM 
	parking_violation;


					--Matching inconsistent color names
/*
From the sample of records in the parking_violation table, it is clear that the vehicle_color values are not consistent. For example, 'GRY', 'GRAY', and 'GREY'
are all used to describe a gray vehicle. 
In order to consistently represent this color, it is beneficial to use a single value. Fortunately, the DIFFERENCE() function can be used to accomplish this goal.

In this exercise, you will use the DIFFERENCE() function to return records that contain a vehicle_color value that closely matches the string 'GRAY'. 
The fuzzystrmatch module has already been enabled for you.
*/
--Use the DIFFERENCE() function to find parking_violation records having a vehicle_color with a Soundex code that matches the Soundex code for 'GRAY'. 
--Recall that the DIFFERENCE() function accepts string values (not Soundex codes) as parameter arguments.


SELECT
  summons_number,
  vehicle_color
FROM
  parking_violation
WHERE
  -- Match SOUNDEX codes of vehicle_color and 'GRAY'
  DIFFERENCE(vehicle_color, 'GRAY') = 4;



					--Standardizing color names
/*
In the previous exercise, the DIFFERENCE() function was used to identify colors that closely matched our desired representation of the color GRAY. 
However, this approach retained a number of records where the vehicle_color value may or may not be gray. Specifically, the string GR (green) has the same 
Soundex code as the string GRAY. Fortunately, records with these vehicle_color values can be excluded from the set of records that should be changed.

In this exercise, you will assign a consistent gray vehicle_color value by identifying similar strings that represent the same color. 
Again, the fuzzystrmatch module has already been installed for you.
*/

/*
Complete the SET clause to assign 'GRAY' as the vehicle_color for records with a vehicle_color value having a matching Soundex code to the Soundex code for 'GRAY'.
Update the WHERE clause of the subquery so that the summons_number values returned exclude summons_number values from records with 'GR' as the vehicle_color value.
*/

UPDATE 
	parking_violation
SET 
	-- Update vehicle_color to `GRAY`
	vehicle_color = 'GRAY'
WHERE 
	summons_number IN (
      SELECT summons_number
      FROM parking_violation
      WHERE
        DIFFERENCE(vehicle_color, 'GRAY') = 4 AND
        -- Filter out records that have GR as vehicle_color
        vehicle_color != 'GR'
);



					--Standardizing multiple colors
/*
After the success of standardizing the naming of GRAY-colored vehicles, you decide to extend this approach to additional colors. 
The primary colors RED, BLUE, and YELLOW will be used for extending the color name standardization approach. In this exercise, you will:

-Find vehicle_color values that are similar to RED, BLUE, or YELLOW.
-Handle both the ambiguous vehicle_color value BL and the incorrectly identified vehicle_color value BLA using pattern matching.
-Update the vehicle_color values with strong similarity to RED, BLUE, or YELLOW to the standard string values.
*/

--1 Generate columns (red, blue, yellow) storing the DIFFERENCE() value for each vehicle_color compared to the strings RED, BLUE, and YELLOW.
--Restrict the returned records to those with a DIFFERENCE() value of 4 for one of RED, BLUE, or YELLOW.

SELECT 
	summons_number,
	vehicle_color,
    -- Include the DIFFERENCE() value for each color
	DIFFERENCE(vehicle_color, 'RED') AS "red",
	DIFFERENCE(vehicle_color, 'BLUE') AS "blue",
	DIFFERENCE(vehicle_color, 'YELLOW') AS "yellow"
FROM
	parking_violation
WHERE 
	(
      	-- Condition records on DIFFERENCE() value of 4
		DIFFERENCE(vehicle_color, 'RED') = 4 OR
		DIFFERENCE(vehicle_color, 'BLUE') = 4 OR
		DIFFERENCE(vehicle_color, 'YELLOW') = 4
	)
	
	
--2 Update the SELECT query to match BL or BLA vehicle_color values using the regular expression pattern 'BLA?' and exclude these records from the result.

SELECT 
	summons_number,
    vehicle_color,
	DIFFERENCE(vehicle_color, 'RED') AS "red",
	DIFFERENCE(vehicle_color, 'BLUE') AS "blue",
	DIFFERENCE(vehicle_color, 'YELLOW') AS "yellow"
FROM
	parking_violation
WHERE
	(
		DIFFERENCE(vehicle_color, 'RED') = 4 OR
		DIFFERENCE(vehicle_color, 'BLUE') = 4 OR
		DIFFERENCE(vehicle_color, 'YELLOW') = 4
    -- Exclude records with 'BL' and 'BLA' vehicle colors
	) AND vehicle_color NOT SIMILAR TO 'BLA?'


--3 Use the records from the previously executed SELECT statement (now stored in a table named red_blue_yellow) to update the vehicle_color values 
--where strong similarity (a value of 4) to RED, BLUE, or YELLOW was identified.






					--Formatting text for colleagues
/*
A website to monitor filming activity in New York City is being constructed based on film permit applications stored in film_permit. 
This website will include information such as an event_id, parking restrictions required for the filming (parking_held), and the purpose of the filming.

Your task is to deliver data to the web development team that will not require the team to perform further cleaning. event_id values will need to be padded with 
0s in order to have a uniform length, capitalization for parking will need to be modified to only capitalize the initial letter of a word, and extra spaces from
parking descriptions will need to be removed. The REGEXP_REPLACE() function (introduced in one of the previous exercises) will be used to clean the extra spaces.
*/

--1 Use the LPAD() function to complete the query so that each event_id is always 10 digits in length with preceding 0s added for any event_id less than 10 digits.



  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
