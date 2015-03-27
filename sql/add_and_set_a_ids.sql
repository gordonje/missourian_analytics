
-- add article_id column
ALTER TABLE messages_links
ADD COLUMN article_id INT;

-- set the article_id
UPDATE messages_links
SET article_id = TRIM((regexp_matches(url_path, '/\d+/'))[1], '/')::INT
WHERE url_path LIKE '/a/%';