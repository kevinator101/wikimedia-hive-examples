SELECT
LEFT(uri_host, LEN(uri_host)-5),
	country,
	uniques_estimate as uniques
FROM 
	wmf.last_access_uniques_monthly
WHERE
	year = 2016
	and month = 1



-- get uniques per month
select 
  concat(month,'/',day,'/',year) as d,
  uri_host, 
  country,
  sum(uniques_estimate) as uniques
from wmf.last_access_uniques_monthly
where
  year = 2016
  AND month = 1
group by year, month, day, uri_host, country
;


--get uniques per month
SELECT
  month,
  uri_host,
  country,
  sum(uniques_estimate) as uniques
FROM
  wmf.last_access_uniques_monthly
WHERE
  year = 2016
GROUP BY
  month,
  uri_host,
  country
;

--get uniques per day
SELECT
  concat(month,'/',day,'/',year) as dia,
  uri_host,
  country,
  sum(uniques_estimate) as uniques
FROM
  wmf.last_access_uniques_daily
WHERE
  year = 2016
GROUP BY
  year,
  month,
  day,
  uri_host,
  country
;


--Get pageviews for February to join with uniques
ADD JAR /srv/deployment/analytics/refinery/artifacts/refinery-hive.jar;
CREATE TEMPORARY FUNCTION country_name as 'org.wikimedia.analytics.refinery.hive.CountryNameUDF';
SELECT
  project,
  country_name(country_code) as country,
  access_method,
  sum(view_count) as pvs
FROM
  wmf.projectview_hourly
WHERE
  year = 2016
  and month = 2
  and (access_method like "desktop" or access_method like "mobile web")
GROUP BY 
  project, country_code, access_method
;

