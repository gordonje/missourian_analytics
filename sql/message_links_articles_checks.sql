
-- 32,610 message / link combinations
SELECT COUNT(*)
FROM messages_links
WHERE article_id IS NOT NULL;

-- 11,494 distinct articles
SELECT COUNT(DISTINCT article_id)
FROM messages_links;

-- among 18,999 distinct messages
SELECT COUNT(DISTINCT message_id)
FROM messages_links
WHERE article_id IS NOT NULL;

-- Each article was shared an average of 2.84 times
SELECT AVG(message_count)
FROM (
        SELECT article_id, COUNT(*) as message_count
        FROM messages_links
        WHERE article_id IS NOT NULL
        GROUP BY article_id
) AS foo;
