SELECT
	user_agent_map["os_family"] AS OS,
	user_agent_map["browser_family"] AS UA,
	zero_carrier,
	sum(view_count) as i
FROM
	wmf.pageview_hourly
WHERE
	year = 2016
	AND month = 2
	AND day = 1
	AND agent_type = "user"
	AND access_method = "mobile web"
	AND country_code = "ZA"
	AND (zero_carrier is NULL OR zero_carrier = "655-12")
GROUP BY
	user_agent_map["os_family"],
	user_agent_map["browser_family"],
	zero_carrier
ORDER BY
	i
LIMIT 1000000
;



output:
502-16  {"browser_major":"-","os_family":"Android","os_major":"4","device_family":"Lenovo A889","browser_family":"Other","os_minor":"2","wmf_app_version":"-"}  1
502-16  {"browser_major":"10","os_family":"Android","os_major":"-","device_family":"Generic Smartphone","browser_family":"Opera Mini","os_minor":"-","wmf_app_version":"-"}     4
502-16  {"browser_major":"10","os_family":"Android","os_major":"4","device_family":"Lenovo TAB 2 A7-30HC","browser_family":"UC Browser","os_minor":"4","wmf_app_version":"-"}   1
502-16  {"browser_major":"10","os_family":"Windows Phone","os_major":"8","device_family":"Lumia 625","browser_family":"IE Mobile","os_minor":"0","wmf_app_version":"-"} 2
502-16  {"browser_major":"11","os_family":"Linux","os_major":"-","device_family":"Other","browser_family":"Chrome","os_minor":"-","wmf_app_version":"-"}        1
502-16  {"browser_major":"12","os_family":"iOS","os_major":"-","device_family":"iPhone","browser_family":"Opera Mini","os_minor":"-","wmf_app_version":"-"}     1
502-16  {"browser_major":"12","os_family":"iOS","os_major":"9","device_family":"iPhone","browser_family":"Opera Mini","os_minor":"2","wmf_app_version":"-"}     2
502-16  {"browser_major":"14","os_family":"Android","os_major":"-","device_family":"Generic Smartphone","browser_family":"Opera Mini","os_minor":"-","wmf_app_version":"-"}     19
502-16  {"browser_major":"2","os_family":"Android","os_major":"2","device_family":"Samsung GT-S5360","browser_family":"Android","os_minor":"3","wmf_app_version":"-"}   38
502-16  {"browser_major":"2","os_family":"Other","os_major":"-","device_family":"Samsung GT-S3850","browser_family":"Dolfin","os_minor":"-","wmf_app_version":"-"}      1
502-16  {"browser_major":"26","os_family":"Android","os_major":"-","device_family":"Generic Smartphone","browser_family":"Opera Mini","os_minor":"-","wmf_app_version":"-"}     1
502-16  {"browser_major":"28","os_family":"Android","os_major":"4","device_family":"C2305","browser_family":"Chrome Mobile","os_minor":"2","wmf_app_version":"-"}       1
502-16  {"browser_major":"28","os_family":"Android","os_major":"4","device_family":"R1001","browser_family":"Chrome Mobile","os_minor":"2","wmf_app_version":"-"}       3
502-16  {"browser_major":"28","os_family":"Android","os_major":"4","device_family":"Samsung SM-G7102","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}    9
502-16  {"browser_major":"30","os_family":"Android","os_major":"4","device_family":"Asus Z007","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}   14
502-16  {"browser_major":"30","os_family":"Android","os_major":"4","device_family":"Cactus","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}      1
502-16  {"browser_major":"30","os_family":"Android","os_major":"4","device_family":"NOTE DELIGHT 1S","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}     2
502-16  {"browser_major":"30","os_family":"Android","os_major":"4","device_family":"Samsung SM-910U","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}     1
502-16  {"browser_major":"33","os_family":"Android","os_major":"4","device_family":"N5206","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}       3
502-16  {"browser_major":"33","os_family":"Windows 8.1","os_major":"-","device_family":"Other","browser_family":"Opera","os_minor":"-","wmf_app_version":"-"}   1
502-16  {"browser_major":"34","os_family":"Android","os_major":"4","device_family":"Samsung SM-G318HZ","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}   3
502-16  {"browser_major":"34","os_family":"Android","os_major":"4","device_family":"Samsung SM-J100H","browser_family":"Chrome Mobile","os_minor":"4","wmf_app_version":"-"}    8


--zero rating test

SELECT
	user_agent_map["browser_family"] AS UA,
	x_analytics_map["zero"] as zero_carrier,
	is_zero,
	sum(*) as i
FROM
	wmf.webrequest
WHERE   
	year = 2016
	AND month = 2
	AND day = 1
	AND hour = 0
	AND is_pageview is true
	AND agent_type = "user"
	AND access_method = "mobile web"
	AND geocoded_data["country_code"] = "ZA"
	AND user_agent_map["browser_family"] = "Opera Mini"
	AND (x_analytics_map["zero"] is NULL OR x_analytics_map["zero"] = "655-12")
GROUP BY
	user_agent_map["browser_family"],
	x_analytics_map["zero"],
	is_zero
ORDER BY
	i DESC
LIMIT 1000000
;


SELECT
	access_method, 
	sum(view_count) as views
FROM
	wmf.pageview_hourly
WHERE
	year = 2016
	AND month = 2
	AND (day = 22 or day = 23 or day = 24 or day = 25 or day = 26 or day = 27 or day = 28 or day = 29)
	AND project like "%.wikipedia"
	AND agent_type = "user"
	AND zero_carrier = "429-02"
	AND user_agent_map["browser_family"] <> "Opera Mini"
GROUP BY
	access_method
LIMIT 10000000;



-- get ratio opera to not opera
SELECT
	access_method,
	CASE WHEN user_agent_map["browser_family"] like "Opera%" THEN "Opera"
               ELSE "Other" END,
	sum(view_count) as views
FROM
	wmf.pageview_hourly
WHERE
	year = 2016
	AND month = 2
	AND (day = 22 or day = 23 or day = 24 or day = 25 or day = 26 or day = 27 or day = 28 or day = 29)
	AND project like "%.wikipedia"
	AND agent_type = "user"
	AND zero_carrier = "429-02"
GROUP BY
	access_method,
	CASE WHEN user_agent_map["browser_family"] like "Opera%" THEN "Opera"
               ELSE "Other" END
LIMIT 10000000;



--last week of February
mobile app	106,247
desktop		33,792
mobile web	260,691

0	2/29/2016	desktop	5855
1	2/29/2016	mobile app	14382
2	2/29/2016	mobile web	32917


access_method   	_c1     		views
mobile app      	Other   		106247
desktop 			Opera Mini      14,007
desktop 			Other   		337,92
mobile web      	Other   		260,691
mobile web      	Opera Mini      366,287


	AND (user_agent_map["browser_family"] <> "Opera Mini" or user_agent_map["browser_family"] is NULL)



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
	access_method,
LIMIT 10000000;
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

