
ALTER TABLE social_flow 
ADD COLUMN hash_tag_count INT DEFAULT 0;

UPDATE social_flow
SET hash_tag_count = b.num_matches
FROM (
        SELECT id, COUNT(*) as num_matches
        FROM (
                SELECT id, regexp_matches(message, '#\w+', 'g') 
                FROM social_flow
        ) as foo
        GROUP BY id
) as b
WHERE social_flow.id = b.id;