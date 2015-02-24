
CREATE TABLE hash_tags AS
SELECT id as message_id, regexp_matches(message, '#\w+', 'g') as hash_tag
FROM social_flow;

ALTER TABLE social_flow
ADD COLUMN hash_tag_count INT DEFAULT 0;

UPDATE social_flow
SET hash_tag_count = the_count
FROM (
        SELECT message_id, COUNT(*) as the_count
        FROM hash_tags
        GROUP BY 1
) as foo
WHERE id = message_id;
