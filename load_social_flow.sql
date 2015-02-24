
COPY social_flow
FROM '/Users/gordo/missourian_analytics/data/Feb12to15_feb_09.csv'
WITH CSV HEADER NULL '';

-- should only affect empty lines, probably at the end of the file
DELETE FROM social_flow where publish_date is NULL;

UPDATE social_flow
SET Reach = NULL
WHERE Reach = 'None';

ALTER TABLE social_flow 
ALTER COLUMN Reach TYPE BIGINT USING CAST(Reach AS INTEGER);

ALTER TABLE social_flow 
RENAME TO social_flow_temp;

CREATE TABLE social_flow AS
SELECT row_number() over (ORDER BY publish_date, time_utc) as id, *
FROM social_flow_temp;

ALTER TABLE social_flow
ADD PRIMARY KEY (id);

DROP TABLE social_flow_temp;


