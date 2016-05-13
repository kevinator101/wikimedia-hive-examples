SELECT concat(month,'/',day,'/',year), country, agent_type, access_method, sum(view_count)
FROM wmf.pageview_hourly
WHERE
  year = 2015
  AND (month = 6 OR month = 7 OR month = 8)
  AND project = "zh.wikipedia"
group by year, month, day, country, agent_type, access_method
;


SELECT
	access_method, agent_type, http_method, uri_query, x_analytics_map, is_pageview
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 9
	AND day = 1
	AND hour = 0
	AND uri_query like "%action=%"
limit 1000
;



SELECT
	count(*) as cnt, referer, user_agent, x_analytics_map['nocookies']
FROM
	wmf.webrequest
WHERE
	year = 2015
	AND month = 11
	AND day = 2
	AND hour = 0
	AND is_pageview = true
	AND pageview_info['page_title'] = "Black_hole"
GROUP BY
  referer, user_agent, x_analytics_map['nocookies']
ORDER BY
  cnt DESC
LIMIT 100
;


-- Give me total pageviews by users in Mexico to any lanugage Wikipedia,
-- separating out desktop, mobile web and mobile app (access method)
-- by day for the month of November.
--
SELECT
	concat(month,'/',day,'/',year) as d,
	access_method, 
	sum(view_count) as views
FROM
	wmf.pageview_hourly
WHERE
	year = 2015
	AND month = 11
	AND agent_type = "user"
	AND country = "Mexico"
	AND project like "%.wikipedia"
GROUP BY
	year, month, day, access_method
ORDER BY
	d ASC
LIMIT 10000000
;


--- Mobile pageviews for a zero rated partner
SELECT
	concat(month,'/',day,'/',year) as d,
	access_method, 
	sum(view_count) as views
FROM
	wmf.pageview_hourly
WHERE
	year = 2015
	AND month = 11
	AND day = 1
	AND hour = 0
	AND agent_type = "user"
	AND zero_carrier = "429-02"
GROUP BY
	year, month, day, access_method
ORDER BY
	d ASC
LIMIT 10000000
;


--- Determining pageviews to various projects
SELECT
	project, 
	sum(view_count) as views
FROM
	wmf.pageview_hourly
WHERE
	year = 2016
	AND month = 1
	AND day = 31
	AND agent_type = "user"
	AND access_method = "mobile web"
	AND country = "Bangladesh"
GROUP BY
	project
ORDER BY
	views DESC
LIMIT 10000
;


--- Determining ratio of pageviews to various projects
SELECT
	project, 
	sum(view_count) as views
FROM
	wmf.pageview_hourly
WHERE
	year = 2016
	AND month = 1
	AND day = 31
	AND agent_type = "user"
	AND access_method = "mobile web"
	AND country = "Bangladesh"
GROUP BY
	project
ORDER BY
	views DESC
LIMIT 10000
;
