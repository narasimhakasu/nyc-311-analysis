create or replace table `nyc-311-servicerequests.staging.raw_data` as
select *
from `bigquery-public-data.new_york_311.311_service_requests`
where created_date between '2021-01-01' AND '2021-11-8'
