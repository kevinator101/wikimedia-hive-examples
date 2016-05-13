SELECT
	count(*) as hits, sum(response_size) as bytes,
	geocoded_data["country"] as country,
	x_analytics_map["zero"] as zero,
	uri_host, uri_path, uri_query,
	user_agent_map["browser_family"] as browser, user_agent_map["os_family"] as os
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 11
	AND day = 15
	AND (geocoded_data["country"] = "Nepal" or x_analytics_map["zero"] = "429-02")
GROUP BY
	geocoded_data["country"], x_analytics_map["zero"], 
	uri_host, uri_path, uri_query, 
	user_agent_map["browser_family"], user_agent_map["os_family"]
ORDER BY
	bytes DESC
LIMIT
	10000000
;
