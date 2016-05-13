ADD JAR /srv/deployment/analytics/refinery/artifacts/refinery-hive.jar;
CREATE TEMPORARY FUNCTION ua as 'org.wikimedia.analytics.refinery.hive.UAParserUDF';

SELECT 
  geocoded_data['continent'], 
  geocoded_data['country'], 
  geocoded_data['subdivision'], 
  geocoded_data['city'], 
  sum(response_size),
  count(*)
FROM wmf.webrequest
WHERE
  year = 2015 AND month = 3 AND day < 8
  AND is_pageview = TRUE
  AND ua(user_agent)['device_family'] = "Spider"
GROUP BY 
  geocoded_data['continent'], 
  geocoded_data['country'], 
  geocoded_data['subdivision'], 
  geocoded_data['city']
;

