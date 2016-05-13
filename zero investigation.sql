SELECT
	count(*), geocoded_data["country"] as country
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 11
	AND day = 15
	AND hour = 0
	AND is_zero = true
	AND x_analytics_map["zero"] = "429-02"
GROUP BY
	geocoded_data["country"]
;

-- Research what is the most consumed piece of data
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


-- Who is downloading most?
SELECT
	count(*) as hits, sum(response_size) as bytes,
	geocoded_data["country"], x_analytics_map["zero"], client_ip, user_agent
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 11
	AND day = 15
	AND hour = 1
	AND (geocoded_data["country"] = "Nepal" or x_analytics_map["zero"] = "429-02")
GROUP BY
	geocoded_data["country"], x_analytics_map["zero"], client_ip, user_agent
ORDER BY
	bytes DESC
LIMIT
	10000000
;


	AND is_zero = true
	AND x_analytics_map["zero"] = "429-02"

en.m.wikipedia.org/w/load.php?debug=false&lang=en&modules=jquery%2Cmediawiki&only=scripts&skin=minerva&version=rXjbPzQq


-- What is in user_agent_map?
SELECT
	count(*) as hits, sum(response_size) as bytes,
	user_agent,
	user_agent_map
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 11
	AND day = 15
	AND hour = 0
	AND (geocoded_data["country"] = "Nepal" or x_analytics_map["zero"] = "429-02")
GROUP BY
	year, month, day, user_agent, user_agent_map
ORDER BY
	bytes DESC
LIMIT
	1000000
;


-- Who (IP/UA) is downloading over time?
SELECT
	concat(month,'/',day,'/',year) as d,
	count(*) as hits, sum(response_size) as bytes,
	client_ip, user_agent
FROM
	wmf.webrequest
TABLESAMPLE
	(BUCKET 1 OUT OF 32 ON rand())
WHERE
	year = 2015
	AND month = 11
	AND (day = 12 OR day  = 13 OR day = 14 OR day = 15 OR day = 16)
	AND x_analytics_map["zero"] = "429-02"
GROUP BY
	year, month, day, client_ip, user_agent
ORDER BY
	d ASC, bytes DESC
LIMIT
	10000000
;

-- Who is downloading the most?
-- zero-1 who is downloading the most.csv
SELECT
	count(*) as hits, sum(response_size) as bytes,
	client_ip
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 11
	AND day = 15
	AND x_analytics_map["zero"] = "429-02"
GROUP BY
	client_ip
;


-- What are they downloading
-- zero-3 when are they downloading.csv
SELECT
	count(*) as hits, sum(response_size) as bytes,
	uri_host, uri_path,
	user_agent_map["browser_family"] as browser
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 11
	AND day = 15
	AND client_ip = "36.252.1.187"
	AND user_agent_map["browser_family"] = "Windows 8"
GROUP BY
	client_ip, uri_host, uri_path,
	user_agent_map["browser_family"]
;

yarn application -movetoqueue application_1441303822549_295672 -queue priority

