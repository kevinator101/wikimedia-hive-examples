-- get ratio opera to not opera
SELECT
	access_method,
	sum(view_count) as views
FROM
	wmf.pageview_hourly
WHERE
	year = 2016
	AND month = 2
	AND day = 29
	AND hour = 0
	AND project like "%.wikipedia"
	AND agent_type = "user"
	AND zero_carrier = "429-02"
GROUP BY
	access_method
;
-- show desktop, mobile, app, opera counts
SELECT
	sum(view_count) as Opera
FROM
	wmf.pageview_hourly
WHERE
	year = 2016
	AND month = 2
	AND day = 29
	AND hour = 0
	AND project like "%.wikipedia"
	AND agent_type = "user"
	AND zero_carrier = "429-02"
	AND user_agent_map["browser_family"] = "Opera Mini"
;
