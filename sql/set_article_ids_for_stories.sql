UPDATE messages_links as a
SET article_id = b.article_id
FROM (
	SELECT DISTINCT 
		  article_id
		, extract('year' from pub_time)::INT as year
		, extract('month' from pub_time)::INT as month
		, extract('day' from pub_time)::INT as day
		, article_slug
    FROM articles_sections
) as b
WHERE 
	lower(rtrim(substring(a.url_path FROM 21 FOR 400), '/')) = b.article_slug
AND substring(a.url_path FROM 10 FOR 4)::INT = b.year
AND substring(a.url_path FROM 15 FOR 2)::INT = b.month
AND substring(a.url_path from 18 for 2)::INT = b.day
AND a.url_path LIKE '/stories/%'
AND substring(a.url_path FROM 10 for 4) ~ E'^\\d+$';