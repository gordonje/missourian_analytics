-- import the data from the .csv file
COPY social_flow
FROM '/Users/gordo/missourian_analytics/data/Feb12to15_feb_09.csv' -- change to your own path
WITH CSV HEADER NULL '';

-- should only affect empty lines, probably at the end of the file
DELETE FROM social_flow where publish_date is NULL;

-- Fixing NULL equvalent in this one field
UPDATE social_flow
SET Reach = NULL
WHERE Reach = 'None';

-- Setting the appropriate data type for this field
ALTER TABLE social_flow 
ALTER COLUMN Reach TYPE BIGINT USING CAST(Reach AS INTEGER);

-- In order to add the serialized primary key
-- 1. rename the table
ALTER TABLE social_flow 
RENAME TO social_flow_temp;
-- 2. create a new table, adding an id field that is set to the row number
-- with rows ordered from earliest to latest publish_date
CREATE TABLE social_flow AS
SELECT row_number() over (ORDER BY publish_date, time_utc) as id, *
FROM social_flow_temp;
-- 3. Set the id as a primary key
ALTER TABLE social_flow
ADD PRIMARY KEY (id);
-- 4. Drop the original table.
DROP TABLE social_flow_temp;


