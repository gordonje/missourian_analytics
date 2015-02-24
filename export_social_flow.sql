
COPY social_flow
TO '/Users/gordo/missourian_analytics/data/Feb12to15_feb_09_appd.csv'
WITH CSV HEADER NULL '';

COPY hash_tags
TO '/Users/gordo/missourian_analytics/data/social_flow_hash_tags.csv'
WITH CSV HEADER NULL '';

COPY at_tags
TO '/Users/gordo/missourian_analytics/data/social_flow_at_tags.csv'
WITH CSV HEADER NULL '';