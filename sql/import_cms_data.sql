DROP TABLE articles_sections;
-- create the table with fields as character data type
CREATE TABLE articles_sections (
        article_id VARCHAR(255)
      , hed VARCHAR(255)
      , pub_time TIMESTAMP
      , article_slug VARCHAR(255)
      , status VARCHAR(255)
      , section_id VARCHAR(255)
      , section_name VARCHAR(255)
      , is_active VARCHAR(255)
      , paywall VARCHAR(255)
      , paywall_always VARCHAR(255)
      , parent_section_id VARCHAR(255)
      , parent_hed VARCHAR(255)
      , parent_is_active VARCHAR(255)
      , parent_paywall VARCHAR(255)
      , parent_paywall_always VARCHAR(255)
);

-- copy records into the table
COPY articles_sections
FROM '/Users/gordo/missourian_analytics/data/cms_data.csv'
WITH DELIMITER '|'  NULL AS '\\N' ESCAPE E'\\' CSV;

-- update all \N values to NULL
UPDATE articles_sections
SET parent_section_id = NULL, parent_hed = NULL, parent_is_active = NULL, parent_paywall = NULL, parent_paywall_always = NULL
WHERE parent_section_id = '\N';

-- change data types for int fields
ALTER TABLE articles_sections
ALTER COLUMN article_id TYPE INT USING article_id::INT,
ALTER COLUMN section_id TYPE INT USING section_id::INT,
ALTER COLUMN parent_section_id TYPE INT USING parent_section_id::INT;