
COPY social_flow
TO '/Users/gordo/missourian_analytics/data/Feb12to15_feb_09_appd.csv'
WITH CSV HEADER NULL '';

COPY messages_hashtags
TO '/Users/gordo/missourian_analytics/data/social_flow_hashtags.csv'
WITH CSV HEADER NULL '';

COPY messages_handles
TO '/Users/gordo/missourian_analytics/data/social_flow_handles.csv'
WITH CSV HEADER NULL '';

COPY messages_links
TO '/Users/gordo/missourian_analytics/data/social_flow_links.csv'
WITH CSV HEADER NULL '';