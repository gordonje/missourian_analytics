
CREATE TABLE messages_links AS
SELECT id as message_id, regexp_matches(message, 'http://[\w./-]+', 'g') as link
FROM social_flow;

ALTER TABLE social_flow
ADD COLUMN link_count INT DEFAULT 0;

UPDATE social_flow
SET link_count = the_count
FROM (
        SELECT message_id, COUNT(*) as the_count
        FROM messages_links
        GROUP BY 1
) as foo
WHERE id = message_id; 
