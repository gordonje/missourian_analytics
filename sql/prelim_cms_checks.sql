-- There are 107,422 articles
SELECT COUNT(*)
FROM core_article;

-- Most articles are filed in at least on section of the Missourian
-- There are 379 that are not, most of which were published in 2008 or 2009, some in 2013 
SELECT *
FROM core_article
WHERE id NOT IN (
        SELECT article_id
        FROM core_article_sections
)
ORDER BY pub_time DESC;

-- 52,983 articles in multiple sections
SELECT COUNT(*)
FROM (
        SELECT article_id, COUNT(*)
        FROM core_article
        JOIN core_article_sections
        ON core_article.id = core_article_sections.article_id
        GROUP BY article_id
        HAVING COUNT(*) > 1
) as foo;

-- Get the ones filed in the highest number of sections
SELECT article_id, COUNT(*)
FROM core_article
JOIN core_article_sections
ON core_article.id = core_article_sections.article_id
GROUP BY article_id
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;
