-- output messages
COPY (
        SELECT *
        FROM social_flow
) TO '/Users/gordo/missourian_analytics/data/messages.csv' DELIMITER ',' CSV HEADER; -- change to your own path

-- output flat_file
COPY (
        SELECT *
        FROM messages_links a
        JOIN social_flow b
        ON a.message_id = b.id
        JOIN articles_sections c
        ON a.article_id = c.article_id
        WHERE a.article_id IS NOT NULL
        ORDER BY a.article_id, c.section_id, a.message_id
) TO '/Users/gordo/missourian_analytics/data/flat_file.csv' DELIMITER ',' CSV HEADER; -- change to your own path

-- output articles_stats
COPY (
        SELECT *
        FROM articles_stats
) TO '/Users/gordo/missourian_analytics/data/articles_stats.csv' DELIMITER ',' CSV HEADER; -- change to your own path
