
COPY social_flow
FROM '/Users/gordo/missourian_analytics/data/Feb12to15_feb_09.csv'
WITH CSV HEADER NULL '';

UPDATE social_flow
SET Reach = NULL
WHERE Reach = 'None';

ALTER TABLE social_flow ALTER COLUMN Reach TYPE BIGINT USING CAST(Reach AS INTEGER);

