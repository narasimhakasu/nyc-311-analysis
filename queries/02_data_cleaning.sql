-- Step 1: Create Cleaned Table
CREATE OR REPLACE TABLE `nyc-311-service-requests.nyc_311.nyc_311_clean` AS
SELECT
  -- Borough cleaning
  CASE 
    WHEN borough IS NULL THEN 'Unknown'
    ELSE borough
  END AS borough,


  -- Agency
  agency,

  -- Dates
  created_date,
  closed_date,


  -- Feature: Response time in hours
  TIMESTAMP_DIFF(closed_date, created_date, HOUR) AS response_time_hrs,

  -- Feature: Month
  EXTRACT(MONTH FROM created_date) AS month,

  -- Feature: Day of week
  EXTRACT(DAYOFWEEK FROM created_date) AS day_of_week,

  -- Feature: Complaint grouping
  CASE
    WHEN complaint_type LIKE '%Noise%' THEN 'Noise'
    WHEN complaint_type LIKE '%HEAT%' OR complaint_type LIKE '%Hot Water%' OR complaint_type like '%Water%' or complaint_type like '%WATER %' OR complaint_type like '%Plu%' THEN 'Water'
    WHEN complaint_type LIKE '%Illegal Parking%' or complaint_type LIKE '%Traffic%' or complaint_type LIKE '%Blocked Driveway%' OR complaint_type like '%Ab%'  THEN 'Parking & Traffic'
    WHEN complaint_type LIKE '%Sanitation%' OR complaint_type LIKE '%Dirty%' OR complaint_type LIKE '%SAN%' OR complaint_type LIKE '%Missed%'OR complaint_type LIKE '%Se%'  THEN 'Waste Management'
    WHEN complaint_type LIKE '%Street %' THEN 'Street'
    WHEN complaint_type like '%Tree%' THEN 'Trees'
    ELSE 'Other'
  END AS complaint_group,

  --status
  CASE 
    WHEN status IS NULL THEN 'Unknown'
    ELSE status
  END AS status  ,

  

FROM `nyc-311-service-requests.nyc_311.table_raw`
WHERE created_date IS NOT NULL
  AND closed_date IS NOT NULL
  AND closed_date >= created_date;