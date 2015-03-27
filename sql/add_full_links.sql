
-- Add columns to messages_links table
ALTER TABLE messages_links
ADD COLUMN full_link VARCHAR(400),
ADD COLUMN scheme  VARCHAR(255), 
ADD COLUMN netloc VARCHAR(255), 
ADD COLUMN url_path VARCHAR(400), 
ADD COLUMN params VARCHAR(400), 
ADD COLUMN query VARCHAR(400), 
ADD COLUMN fragment VARCHAR(400);

-- Populate new fields with scraped URLs
UPDATE messages_links as a
SET full_link = full_url,
scheme = b.scheme,
netloc = b.netloc,
url_path = b.url_path,
params = b.params,
query = b.query,
fragment = b.fragment
FROM short_to_full_urls as b
WHERE a.link = b.short_URL;

