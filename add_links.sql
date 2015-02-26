
CREATE TABLE messages_links AS
SELECT 
          id as message_id
        , (regexp_matches(message, 'http://[\w./-]+'))[1] as link
        , FALSE as primary_link
FROM social_flow;

INSERT INTO messages_links (message_id, link, primary_link)
SELECT id, link, TRUE
FROM social_flow
WHERE link IS NOT NULL;

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
