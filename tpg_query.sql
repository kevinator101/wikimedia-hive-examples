select concat(month,'/',day,'/',year), page_title, access_method, referer_class, country, city, sum(view_count)
from wmf.pageview_hourly
where
  year = 2015
  AND agent_type = "user"
  AND project = "mediawiki"
  AND page_title like "Team_Practices_Group%"
group by year, month, day, page_title, access_method, referer_class, country, city
;

