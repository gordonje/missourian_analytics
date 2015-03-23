-- 35,300 links shared via facebook and twitter
SELECT COUNT(*)
FROM messages_links;

-- All the link include the scheme
SELECT COUNT(*)
FROM messages_links
WHERE link LIKE 'http%';

-- 60 percent of the links aren't direct to columbiamissourian.com
SELECT COUNT(*), COUNT(*)::float / (SELECT COUNT(*) FROM messages_links)::float AS pct
FROM messages_links
WHERE link NOT LIKE 'http://%columbiamissourian.com%';

-- 56 percent go through bit.ly
SELECT COUNT(*), COUNT(*)::float / (SELECT COUNT(*) FROM messages_links)::float AS pct
FROM messages_links
WHERE link LIKE '%bit.ly%'
OR link LIKE '%bitly%';

-- 3 percent go through trib.al
SELECT COUNT(*), COUNT(*)::float / (SELECT COUNT(*) FROM messages_links)::float AS pct
FROM messages_links
WHERE link LIKE '%trib.al%';

-- 441 are links to other content providers
SELECT *
FROM messages_links
WHERE link NOT LIKE '%trib.al%'
AND link NOT LIKE '%bitly%'
AND link NOT LIKE '%bit.ly%'
AND link NOT LIKE 'http://%columbiamissourian.com%'
ORDER BY link;
