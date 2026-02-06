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



SELECT * FROM platforms;

SELECT * FROM roles;

SELECT * FROM companies;

SELECT * FROM applications;


SELECT * FROM interviews;


-- 1.Which platform has the highest interview rate?
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



-- 2.What % of applications are ghosted?

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



-- 3.Average response time per company

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



-- 4.Which roles get most callbacks?

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



-- 5.Monthly application trend

SELECT 
    DATE_FORMAT(applied_date, '%Y-%m') AS month,
    COUNT(application_id) AS total_application
FROM
    applications
GROUP BY month
ORDER BY month;



-- 6.Top companies by success rate
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