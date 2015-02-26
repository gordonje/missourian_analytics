
CREATE TABLE messages_handles AS
SELECT id as message_id, (regexp_matches(message, '@\w+'))[1] as handle
FROM social_flow;

ALTER TABLE social_flow
ADD COLUMN handle_count INT DEFAULT 0;

UPDATE social_flow
SET handle_count = the_count
FROM (
        SELECT message_id, COUNT(*) as the_count
        FROM messages_handles
        GROUP BY 1
) as foo
WHERE id = message_id;