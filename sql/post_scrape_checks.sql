
SELECT 
          COUNT(*) -- 19,918
        , SUM(num_redirects) -- 40,877
        , AVG(num_redirects) -- 2.05
FROM short_to_full_urls;

--
SELECT netloc, COUNT(*)
FROM messages_links
GROUP BY netloc
ORDER BY 2 DESC;

-- 17,741 + 16,312 = 34,053
-- 30,019
SELECT COUNT(*)
FROM messages_links
WHERE netloc IN ('columbiamissourian.com', 'www.columbiamissourian.com')
AND url_path LIKE '/a/%';
-- 2,679
SELECT COUNT(*)
FROM messages_links
WHERE netloc IN ('columbiamissourian.com', 'www.columbiamissourian.com')
AND url_path LIKE '/stories/%';

SELECT full_link
FROM messages_links_new
WHERE netloc IN ('columbiamissourian.com', 'www.columbiamissourian.com')
AND url_path NOT LIKE '/stories/%'
AND url_path NOT LIKE '/a/%'
AND url_path NOT LIKE '/weather%'
ORDER BY url_path;


select *
from messages_links_new
where netloc = 'media.columbiamissourian.com'



select count(*)
from short_to_full_urls
where (netloc like '%columbiamissourian.com'
or netloc like '%voxmagazine.com')
and url_path = '/weather/';

select full_url
from short_to_full_urls
where (netloc like '%columbiamissourian.com'
or netloc like '%voxmagazine.com')
and url_path not like '/a/%';


select *
from short_to_full_urls
order by num_redirects DESC;


SELECT *
FROM messages_links
WHERE url_path LIKE '/stories/%';


select *
from messages_links
where article_id is null
and netloc IN ('columbiamissourian.com', 'www.columbiamissourian.com')
AND (url_path LIKE '/stories/%'
OR url_path LIKE '/a/%')
