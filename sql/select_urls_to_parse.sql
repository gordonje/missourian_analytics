
SELECT *
FROM messages_links
WHERE full_link is null
AND link NOT LIKE '%bit.ly%'
AND link NOT LIKE '%bitly%'
AND link NOT LIKE '%trib.al%'
AND link NOT LIKE '%tribal%'
AND link NOT LIKE '%ow.ly%'
AND link NOT LIKE 'http://t.co%';