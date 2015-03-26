
SELECT DISTINCT link 
FROM messages_links
WHERE (
           link LIKE '%bit.ly%'
        OR link LIKE '%bitly%'
        OR link LIKE '%trib.al%'
        OR link LIKE '%tribal%'
        OR link LIKE '%ow.ly%'
        OR link LIKE '%t.co%'
)
AND link NOT IN (SELECT short_url FROM short_to_full_urls)
ORDER BY link;
