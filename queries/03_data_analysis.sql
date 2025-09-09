

-- 1. Total Complaints (KPI)

SELECT COUNT(*) AS total_complaints
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`;


-- 2. Average Response Time (in days) (KPI)

SELECT AVG(response_time_hrs)/24 AS avg_response_days
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
ORDER BY avg_response_days DESC;

-- 3. Complaints by Group

select complaint_group , count(1) as num
from `nyc-311-service-requests.nyc_311.nyc_311_clean`
group by complaint_group
ORDER BY num desc;



-- 4. Complaints by Borough

SELECT borough,  COUNT(*) AS complaints
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
GROUP BY borough
ORDER BY complaints DESC;




-- 5. Complaints by Agency (Top 10)

SELECT agency, COUNT(*) AS total
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
GROUP BY agency
ORDER BY total DESC
LIMIT 10;


-- 6. Complaints by Day of Week

SELECT 
  EXTRACT(DAYOFWEEK FROM created_date) AS day_num,
  CASE EXTRACT(DAYOFWEEK FROM created_date)
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
  END AS day_name,
  COUNT(*) AS total
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
GROUP BY day_num, day_name
ORDER BY day_num;


-- 7. Average Response Time by Agency
SELECT agency, AVG(response_time_hrs/24) AS avg_response_days
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
GROUP BY agency
ORDER BY avg_response_days DESC;



-- 8. Complaints by Month (Jan - Oct only)

SELECT 
  EXTRACT(MONTH FROM created_date) AS month,
  FORMAT_DATE('%B', DATE(created_date)) AS month_name,
  COUNT(*) AS total
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
WHERE EXTRACT(MONTH FROM created_date) BETWEEN 1 AND 11
GROUP BY month, month_name
ORDER BY month;


--- 9.  Complaints Types Share in Percentage

SELECT 
  complaint_group,
  COUNT(*) AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_share
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`

GROUP BY complaint_group
ORDER BY total DESC
LIMIT 5;

--- 10.  Complaints by Bourough (in %)

SELECT 
  borough,
  COUNT(*) AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_share
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
GROUP BY borough
ORDER BY total DESC;


--- 11.  Agency workload & avg response

SELECT 
  agency,
  COUNT(*) AS total_complaints,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_share,
  ROUND(AVG(TIMESTAMP_DIFF(closed_date, created_date, DAY)),2) AS avg_response_days
FROM `nyc-311-service-requests.nyc_311.nyc_311_clean`
GROUP BY agency
ORDER BY total_complaints desc
