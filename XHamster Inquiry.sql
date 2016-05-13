# Why does XHamster always show up in the top 100 most viewed article each day?
# The Pageview API givex XHamster 224.9 k views on 2016-05-08.

# First, let's start by counting how many times it is viewed on Desktop Wikipedia.
SELECT
	access_method,
	count(1) as x
FROM wmf.webrequest 
where
  year = 2016
  and month = 5
  and day = 8
  and webrequest_source = "text"
  and is_pageview	
  and (uri_host = "en.m.wikipedia.org" or uri_host = "en.wikipedia.org")
  and uri_path = "/wiki/XHamster"
group by 
	access_method
order by x desc
limit 1000;

# Results 
#  	access_method	x
# 	mobile web		215,309
# 	desktop			11,245


# Now, let's focus on the mobile site and look at the referer.
SELECT
	CASE 
		WHEN referer like "https://www.google.%"  THEN "google"
		ELSE referer END,
	count(1) as x
FROM wmf.webrequest 
where
  year = 2016
  and month = 5
  and day = 8
  and webrequest_source = "text"
  and is_pageview	
  and uri_host = "en.m.wikipedia.org" 
  and uri_path = "/wiki/XHamster"
group by 
	CASE 
		WHEN referer like "https://www.google.%"  THEN "google"
		ELSE referer END
order by x desc
limit 10;

# Results for en.m.wikipedia.org
# 
#  	_c0	x
# 0	-	213927
# 1	google	581
# 2	https://duckduckgo.com/	69
# 3	android-app://com.google.android.googlequicksearchbox	43
# 4	http://www.google.com/search?q=xhamster	25
# 5	https://en.wikipedia.org/wiki/XHamster	18
# 6	https://duckduckgo.com	18
# 7	http://in.yhs4.search.yahoo.com/yhs/mobile/search?p=x+hamster	15
# 8	https://en.m.wikipedia.org/wiki/XHamster	15
# 9	https://en.m.wikipedia.org/wiki/YouPorn	12

# from the above, we see that the referer is not set most of the time.

# now let's look at who is downloading the page
SELECT 
	ip,
	count(1) as x
FROM wmf.webrequest 
where
  year = 2016
  and month = 5
  and day = 8
  and webrequest_source = "text"
  and is_pageview	
  and uri_host = "en.m.wikipedia.org" 
  and uri_path = "/wiki/XHamster"
  and referer = "-"
group by 
	ip
order by x desc
limit 10;


# Results (suppressing the IP address)
# 	0.0.0.0		151
# 	0.0.0.0		111
# 	0.0.0.0		107
# 	0.0.0.0		91
# 	0.0.0.0		89
# 	0.0.0.0		88
# 	0.0.0.0		77
# 	0.0.0.0		74
# 	0.0.0.0		67
# 	0.0.0.0		66

# This suggests that most of the pageviews are coming from many different IP addresses


# now lets look to see if the images associated with this page is viewed as often...
SELECT 
	webrequest_source, uri_path, count(*) as x
FROM wmf.webrequest 
where
  year = 2016
  and month = 5
  and day = 8
  and hour = 0
#  and webrequest_source = "misc"
  and uri_host = "upload.wikimedia.org" 
  and uri_path like "/wikipedia/en/thumb/f/ff/Xhamster_logo.jpg%"
group by webrequest_source, uri_path
order by x desc
limit 1000
;


# webrequest_source	uri_path	x
# upload	/wikipedia/en/thumb/f/ff/Xhamster_logo.jpg/250px-Xhamster_logo.jpg		56
# upload	/wikipedia/en/thumb/f/ff/Xhamster_logo.jpg/qlow-250px-Xhamster_logo.jpg	2
# upload	/wikipedia/en/thumb/f/ff/Xhamster_logo.jpg/500px-Xhamster_logo.jpg		2
# upload	/wikipedia/en/thumb/f/ff/Xhamster_logo.jpg/375px-Xhamster_logo.jpg		2
# upload	/wikipedia/en/thumb/f/ff/Xhamster_logo.jpg/120px-Xhamster_logo.jpg		1
# upload	/wikipedia/en/thumb/f/ff/Xhamster_logo.jpg/320px-Xhamster_logo.jpg		1


# Just out of curiosity, what is the user agent for these devices
# I am going to use the pageview hourly table for speed.  I won't be filtering out referer because
# it's not available in this table, but 99% of data had a referer set to '-' anyway.
SELECT
	user_agent_map["os_family"] AS OS,
	user_agent_map["browser_family"] AS UA,
	sum(view_count) as x
FROM
	wmf.pageview_hourly
WHERE
  year = 2016
  and month = 5
  and day = 8
  and agent_type = "user"
  and access_method = "mobile web"
  and project = "en.wikipedia"
  and page_title = "XHamster"
GROUP BY
	user_agent_map["os_family"],
	user_agent_map["browser_family"]
ORDER BY x DESC
LIMIT 1000000
;

# Results:
# 	os			ua					x
#	Android		Android				206371
#	iOS			Mobile Safari		4412
#	iOS			Chrome Mobile iOS	2308

# I am not sure these are really android devices.  I think it's some malicious app that is 
# testing for network connectivity by loading a web page.  It is setting its User Agent string
# to look like an android device.

#We can also look by country...
SELECT
	country,
	sum(view_count) as x
FROM
	wmf.pageview_hourly
WHERE
  year = 2016
  and month = 5
  and day = 8
  and agent_type = "user"
  and access_method = "mobile web"
  and project = "en.wikipedia"
  and page_title = "XHamster"
GROUP BY
	country
ORDER BY x DESC
LIMIT 1000000
;

# Results:
# 	country			x
#	United States	32216
#	Germany			31836
#	United Kingdom	18273
#	France			17676
#	Japan			10957
#	Italy			9327
#	Spain			8430
#	Netherlands		6153
#	Canada			4728
#	Poland			4326
#	Brazil			4094

#Interestingly enough, this is spread out globally and not spread out the way normal pageviews occur:
SELECT
	country,
	sum(view_count) as x
FROM
	wmf.pageview_hourly
WHERE
  year = 2016
  and month = 5
  and day = 8
  and agent_type = "user"
  and access_method = "mobile web"
  and project = "en.wikipedia"
GROUP BY
	country
ORDER BY x DESC
LIMIT 1000000
;

# Results
#	United States	56983231
#	United Kingdom	14334816
#	India	9766523
#	Canada	4939310
#	Australia	4130166
#	Germany	1379171
#	Philippines	1340333
#	South Africa	1197983
#	Ireland	1169488
#	Indonesia	1035821
#	Malaysia	1004607
