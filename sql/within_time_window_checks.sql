-- Within the Social Flow time window, there are 38,146
SELECT COUNT(*)
FROM core_article
WHERE pub_time > '2012-02-15'
AND pub_time < '2015-02-11';

