-- Within the Social Flow time window, there are 38,146
SELECT COUNT(*)
FROM core_article
WHERE pub_time > '2012-02-15'
AND pub_time < '2015-02-11';

-- 23,207 were filed in multiple sections
SELECT COUNT(*)
FROM (
        SELECT article_id, COUNT(*)
        FROM core_article
        JOIN core_article_sections
        ON core_article.id = core_article_sections.article_id
        WHERE pub_time > '2012-02-15'
        AND pub_time < '2015-02-11'
        GROUP BY article_id
        HAVING COUNT(*) > 1
) as foo;

-- Some where filed in as many as six sections
SELECT article_id, COUNT(*)
FROM core_article
JOIN core_article_sections
ON core_article.id = core_article_sections.article_id
WHERE pub_time > '2012-02-15'
AND pub_time < '2015-02-11'
GROUP BY article_id
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Get the proportions of article sections
SELECT section_id, core_section.hed, COUNT(*), COUNT(*) / (SELECT COUNT(*) FROM core_article WHERE pub_time > '2012-02-15' AND pub_time < '2015-02-11') as pct
FROM core_article_sections
JOIN core_section
ON core_section.id = section_id
JOIN core_article
ON core_article.id = core_article_sections.article_id
WHERE pub_time > '2012-02-15'
AND pub_time < '2015-02-11'
GROUP BY 1, 2
ORDER BY COUNT(*) DESC;