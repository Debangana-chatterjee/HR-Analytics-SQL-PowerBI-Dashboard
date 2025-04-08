CREATE DATABASE hr;
use hr;
SELECT * FROM human_resources;

-- Data Cleaning
ALTER TABLE human_resources
CHANGE COLUMN ï»¿id employee_id VARCHAR(20) NOT NULL;
ALTER TABLE human_resources
MODIFY COLUMN employee_id VARCHAR(20) NULL;
DESCRIBE human_resources;

-- Changed the data format and datatype of birthdate column

UPDATE human_resources
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE human_resources
MODIFY COLUMN birthdate DATE;

-- Changed the data format and datatype of hire_date column

UPDATE human_resources
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE human_resources
MODIFY COLUMN hire_date DATE;

-- Changed the data format and datatype of termdate column

UPDATE human_resources
SET termdate = CASE 
        WHEN termdate LIKE '% UTC' THEN LEFT(termdate, 10) 
        WHEN termdate LIKE '%/%' THEN date_format(STR_TO_DATE(termdate, '%m/%d/%Y'),'%Y-%m-%d') 
		WHEN termdate LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE NULL
    END;
ALTER TABLE human_resources
MODIFY COLUMN termdate DATE;

-- created age column

ALTER TABLE human_resources ADD COLUMN age INT;
UPDATE human_resources
SET age = timestampdiff(YEAR, birthdate, CURDATE()); 

