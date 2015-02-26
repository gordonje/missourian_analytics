
CREATE TABLE messages_hashtags AS
SELECT id as message_id, (regexp_matches(message, '#\w+', 'g'))[1] as hashtag
FROM social_flow;

ALTER TABLE social_flow
ADD COLUMN hashtag_count INT DEFAULT 0;

UPDATE social_flow
SET hashtag_count = the_count
FROM (
        SELECT message_id, COUNT(*) as the_count
        FROM messages_hashtags
        GROUP BY 1
) as foo
WHERE id = message_id;

select sum(hashtag_count) from social_flow;
