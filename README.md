# Job Application Tracking & Analytics System (SQL Project)

##  Project Goal
Build a relational database system to track job applications and analyze
application outcomes, response time, ghosting trends, and platform
effectiveness using SQL.

##  Database Schema
The database consists of the following tables:
- applications
- companies
- platforms
- roles
- interviews


## Database Setup
- Database Creation: The project starts by creating a database named **job_tracker** .

- Table Creation: This tables create a relational database which will be helpful to answer many analytical problem.
  - A table named **companies** is created to store the company data. The table structure includes columns for company ID,company name,industry and location.
  - A table named **roles** is created to store the role data which contain role ID,role name and experience level.
  - A table named **platforms** is created to store the platform data containg platform name and platform id columns.
  - Another table named **applications** contain application id,company id,applied date,status,expected salary,role id and platform id.
  - Last table named **interviews** contain interview id,application id,interview round,interview date and result.  

~~~sql
CREATE DATABASE IF NOT EXISTS job_tracker;
USE job_tracker;

CREATE TABLE companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    industry VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(100),
    experience_level VARCHAR(50)
);


CREATE TABLE platforms (
    platform_id INT PRIMARY KEY,
    platform_name VARCHAR(30)
);


CREATE TABLE applications (
    application_id INT PRIMARY KEY,
    company_id INT,
    FOREIGN KEY (company_id)
        REFERENCES companies (company_id),
    role_id INT,
    FOREIGN KEY (role_id)
        REFERENCES roles (role_id),
    platform_id INT,
    FOREIGN KEY (platform_id)
        REFERENCES platforms (platform_id),
    applied_date DATE,
    expected_salary INT,
    status VARCHAR(30)
);

CREATE TABLE interviews (
    interview_id INT PRIMARY KEY,
    application_id INT,
    FOREIGN KEY (application_id)
        REFERENCES applications (application_id),
    interview_round INT,
    interview_date DATE,
    result VARCHAR(30)
);
~~~


## To See all tables here is the query :
~~~sql
SELECT * FROM platforms;

SELECT * FROM roles;

SELECT * FROM companies;

SELECT * FROM applications;

SELECT * FROM interviews;
~~~



##  Data Analysis and Findings
The following SQL queries were developed to answer specific business questions:
**1. Which platform has the highest interview rate?**

```sql
SELECT 
    p.platform_name,
    ROUND(SUM(CASE
                WHEN a.status = 'Interview' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,
            2) AS interview_rate
FROM
    applications a
        JOIN
    platforms p ON a.platform_id = p.platform_id
GROUP BY p.platform_name
ORDER BY interview_rate DESC
LIMIT 1;
```

**2. What percentage of applications are ghosted?**
~~~sql
SELECT 
    status,
    ROUND((COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    applications)) * 100,
            2) AS ghosted_percentage
FROM
    applications
WHERE
    status = 'Ghosted'
GROUP BY status;
~~~
**3. Average response time per company**
~~~sql
SELECT 
    c.company_name,
    ROUND(AVG(DATEDIFF(i.first_interview_date, a.applied_date)),
            0) AS avg_response_delay_days
FROM
    applications a
        JOIN
    (SELECT 
        application_id, MIN(interview_date) AS first_interview_date
    FROM
        interviews
    GROUP BY application_id) i ON a.application_id = i.application_id
        JOIN
    companies c ON a.company_id = c.company_id
GROUP BY c.company_name
ORDER BY avg_response_delay_days;
~~~
**4. Which roles get the most callbacks?**
~~~sql
SELECT 
    r.role_name,
    SUM(CASE
        WHEN a.status = 'Interview' THEN 1
        WHEN a.status = 'Offer' THEN 1
        ELSE 0
    END) AS count_callbacks
FROM
    applications a
        JOIN
    roles r ON r.role_id = a.role_id
GROUP BY r.role_name
ORDER BY count_callbacks DESC
LIMIT 1;
~~~
**5. Monthly application trend**
~~~sql
SELECT 
    DATE_FORMAT(applied_date, '%Y-%m') AS month,
    COUNT(application_id) AS total_application
FROM
    applications
GROUP BY month
ORDER BY month;
~~~
**6. Top companies by success rate**
~~~sql
SELECT 
    c.company_name,
    ROUND((SUM(CASE
                WHEN a.status = 'Interview' THEN 1
                WHEN a.status = 'Offer' THEN 1
                ELSE 0
            END) / COUNT(*)) * 100,
            2) AS success_rate
FROM
    applications a
        JOIN
    companies c ON a.company_id = c.company_id
GROUP BY c.company_name
ORDER BY success_rate DESC;
~~~

## Key Insights
- Indeed named platform convert applications into interviews more efficiently which is 23.4% .
- 20% of applications are ghosted.
- Technova company delays most which is 19 days and NextGen IT ,ByteWorks ,CodeCrafters, CloudNest companies delays most less which is 14 days.
- Frontend Developer receive callbacks more frequently.
- Starting by january 2024 total application was 11 and being highest application on november 2024 year ended with 12 applications on december.
- Success rate of applying was most at NextGen IT company.

##  Tools Used
- MySQL
- SQL (Joins, Aggregations, CASE, Subqueries)

## Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, and business-driven SQL queries. The findings from this project can help drive job application decisions by understanding  patterns, job market, and platform performance.


