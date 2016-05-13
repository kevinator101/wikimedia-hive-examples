SELECT uri_path, country, hits
FROM (
select uri_path, geocoded_data['country'] as country, count(1) as hits
from wmf.webrequest
where
  year = 2015
  and month = 7
  and day <= 15
  and webrequest_source = "misc"
  and uri_host = "releases.wikimedia.org"
  and uri_path like "%.gz"
  and http_status = "200"
group by uri_path, geocoded_data['country']

UNION ALL

select uri_path, country, count(1) as hits
from (
    select DISTINCT HASH(ip, user_agent) as idx, uri_path, geocoded_data['country'] as country
    from wmf.webrequest
    where
      year = 2015
      and month = 7 
      and day <= 15
      and webrequest_source = "misc"
      and uri_host = "releases.wikimedia.org"
      and uri_path like "%.gz"
      and http_status = "206"
) distinct_206
GROUP BY uri_path, country
) union_200_206
order by hits DESC
LIMIT 1000000;
