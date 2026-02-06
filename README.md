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

##  Data Analysis and Findings
- Which platform has the highest interview rate?
  
  ```sql
SELECT p.platform_name,ROUND(
        SUM(CASE WHEN a.status = 'Interview' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100,
        2
    ) AS interview_rate
FROM applications a
JOIN platforms p
    ON a.platform_id = p.platform_id
GROUP BY p.platform_name
ORDER BY interview_rate DESC
LIMIT 1;
```

- What percentage of applications are ghosted?
- Average response time per company
- Which roles get the most callbacks?
- Monthly application trend
- Top companies by success rate

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


