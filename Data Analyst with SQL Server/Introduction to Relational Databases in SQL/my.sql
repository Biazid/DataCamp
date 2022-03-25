--Chapter 2: Enforce data consistency with attribute constraints

--Disallow NULL values with SET NOT NULL
--Add a not-null constraint for the firstname column.
ALTER Table professors 
ALTER COLUMN firstname SET NOT NULL;
--Add a not-null constraint for the lastname column.
ALTER Table professors 
ALTER COLUMN lastname SET NOT NULL;

/* What happens if you try to enter NULLs?
Ans: Because a database constraint is violated. */

--Make your columns UNIQUE with ADD CONSTRAINT
-- Make universities.university_shortname unique
ALTER table universities
ADD constraint university_shortname_unq UNIQUE(university_shortname);
-- Make organizations.organization unique
alter table organizations
add constraint organization_unq unique(organization)

--Chapter 3: Uniquely identify records with key constraints

--Get to know SELECT COUNT DISTINCT
-- Count the number of rows in universities
SELECT count(*)
FROM universities;

-- Count the number of distinct values in the university_city column
SELECT count(distinct(university_city)) 
FROM universities;
---- Try out different combinations
select COUNT(distinct(firstname,lastname)) 
FROM professors;

--Identify the primary key
--Which of the following column or column combinations could best serve as primary key?
--Ans: PK = {license_no}

/*
Rename the organization column to id in organizations.
Make id a primary key and name it organization_pk. */

-- Rename the organization column to id
alter TABLE organizations
Rename column organization to id;

-- Make id a primary key
ALTER TABLE organizations
add Constraint organization_pk primary KEY (id);

/*
Rename the university_shortname column to id in universities.
Make id a primary key and name it university_pk. */
-- Rename the university_shortname column to id
alter table universities
Rename column university_shortname to id ;

-- Make id a primary key
alter table universities
add constraint university_pk primary key(id);

--Surrogate keys
--Add a SERIAL surrogate key
--Add a new column id with data type serial to the professors table. 
-- Add the new column to the table
ALTER TABLE professors 
add column id serial;
--Make id a primary key and name it professors_pkey.
-- Add the new column to the table

-- Make id a primary key
ALTER table professors
add CONSTRAINT professors_pkey primary key (id);

--Write a query that returns all the columns and 10 rows from professors.
-- Have a look at the first 10 rows of professors
select * from professors
limit 10;

--Count the number of distinct rows with a combination of the make and model columns.
-- Count the number of distinct rows with columns make, model
select count(distinct(make,model))
FROM cars;
--Add a new column id with the data type varchar(128).
-- Add the id column
ALTER TABLE cars
add column id varchar(128);
--Concatenate make and model into id using an UPDATE table_name SET column_name = ... query and the CONCAT() function.
-- Update id with make + model
UPDATE cars
set id = concat(make, model);
--Make id a primary key and name it id_pk.
-- Make id a primary key
alter table cars
add constraint id_pk primary key(id);
-- Have a look at the table
SELECT * FROM cars;
--Given the above description of a student entity, create a table students with the correct column types.
--Add a PRIMARY KEY for the social security number ssn.
-- Create the table
create table students (
  last_name varchar(128) not null,
  ssn int primary key,
  phone_no char(12)
);

--chapter 4: Glue together tables with foreign keys
--Rename the university_shortname column to university_id in professors.
-- Rename the university_shortname column
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;
--Add a foreign key on university_id column in professors that references the id column in universities.Name this foreign key professors_fkey.
-- Add a foreign key on professors referencing universities
alter table professors 
add constraint professors_fkey FOREIGN KEY (university_id) REFERENCES universities (id);

-- Try to insert a new professor
INSERT INTO professors (firstname, lastname, university_id)
VALUES ('Albert', 'Einstein', 'UZH');

-- Select all professors working for universities in the city of Zurich
SELECT professors.lastname, universities.id, universities.university_city
from professors
inner join universities
ON professors.university_id = universities.id
where universities.university_city = 'Zurich';

--Add a professor_id column with integer data type to affiliations, and declare it to be a foreign key that references the id column in professors.
-- Add a professor_id column
ALTER TABLE affiliations
ADD COLUMN professor_id integer REFERENCES professors (id);
--Rename the organization column in affiliations to organization_id.'
-- Rename the organization column to organization_id
ALTER TABLE affiliations
RENAME organization TO organization_id;
--Add a foreign key constraint on organization_id so that it references the id column in organizations.
-- Add a foreign key on organization_id
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey foreign key (organization_id) REFERENCES organizations (id);

-- Have a look at the 10 first rows of affiliations
select * from affiliations
limit 10;
--Update the professor_id column with the corresponding value of the id column in professors.
--"Corresponding" means rows in professors where the firstname and lastname are identical to the ones in affiliations.
-- Set professor_id to professors.id where firstname, lastname correspond to rows in professors
UPDATE affiliations
SET professor_id = professors.id
FROM professors
WHERE affiliations.firstname = professors.firstname AND affiliations.lastname = professors.lastname;
--Check out the first 10 rows and all columns of affiliations again. Have the professor_ids been correctly matched?
-- Have a look at the 10 first rows of affiliations again
select * from affiliations
limit 10;

-- Drop the firstname column
alter table affiliations
DROP column firstname;

-- Drop the lastname column
alter table affiliations
DROP column lastname;


