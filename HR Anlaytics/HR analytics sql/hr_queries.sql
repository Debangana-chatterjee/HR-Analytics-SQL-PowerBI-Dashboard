-- Key metrics
SELECT COUNT(*) AS total_hires
FROM human_resources
WHERE hire_date IS NOT NULL AND hire_date<=curdate();

SELECT COUNT(*) AS total_terminations
FROM human_resources
WHERE termdate IS NOT NULL AND termdate<=curdate();

SELECT COUNT(*) AS total_count,
(sum(CASE WHEN termdate IS NOT NULL AND termdate <=curdate() THEN 1 END) * 1.0 / COUNT(*))AS turnover_rate
FROM human_resources;

-- 1. What is the gender breakdown of employees in the company
SELECT gender, COUNT(*) AS count
FROM human_resources
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company
SELECT race, COUNT(*) AS count
FROM human_resources
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company
SELECT 
	CASE
		WHEN age>=18 AND age<=24 THEN '18-24'
        WHEN age>=25 AND age<=34 THEN '25-34'
        WHEN age>=35 AND age<=44 THEN '35-44'
        WHEN age>=45 AND age<=54 THEN '45-54'
        WHEN age>=55 AND age<=64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    COUNT(*) AS count
    FROM human_resources
    WHERE termdate IS NULL
    GROUP BY age_group
    ORDER BY age_group;
    
-- 4. How many employees work at headquarters versus remote locations
SELECT location, COUNT(*) AS count
FROM human_resources
WHERE age >= 18 AND termdate IS NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
round(avg(year(termdate)-year(hire_date)),0) AS avg_length_employment
FROM human_resources
WHERE termdate<=curdate() AND termdate IS NOT NULL AND age>=18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department,gender,COUNT(*) AS count
FROM human_resources
WHERE age >= 18 AND termdate IS NULL
GROUP BY department,gender
ORDER BY department,gender;

SELECT jobtitle,gender,COUNT(*) AS count
FROM human_resources
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle,gender
ORDER BY jobtitle,gender;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle,COUNT(*) AS count
FROM human_resources
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY count DESC;

-- 8. Which department has the highest turnover rate?
SELECT department, COUNT(*) AS total_count,
COUNT(CASE WHEN termdate IS NOT NULL AND termdate <=curdate() THEN 1 END) * 1.0 / COUNT(*) AS turnover_rate
FROM human_resources
WHERE age>=18
GROUP BY department
ORDER BY turnover_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state,COUNT(*) AS count
FROM human_resources
WHERE age>=18 AND termdate IS NULL
GROUP BY location_state
ORDER BY count DESC;

SELECT location_city,COUNT(*) AS count
FROM human_resources
WHERE age>=18 AND termdate IS NULL
GROUP BY location_city
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT
	year,hires,terminations,hires-terminations AS net_change,
	round((hires-terminations)/hires*100,2) AS net_change_percent
FROM
	(SELECT YEAR(hire_date)AS year,COUNT(*)AS hires,
		SUM(CASE 
			WHEN termdate IS NOT NULL AND termdate<=curdate()
			THEN 1
			ELSE 0
			END) AS terminations
	FROM human_resources
	WHERE age>=18
	GROUP BY YEAR(hire_date)
	)AS sub_query
ORDER BY year;

-- 11. What is the tenure distribution for each department?
SELECT department,
round(avg(year(termdate)-year(hire_date)),0) AS avg_tenure
FROM human_resources
WHERE termdate<=curdate() AND termdate IS NOT NULL AND age>=18
GROUP BY department;