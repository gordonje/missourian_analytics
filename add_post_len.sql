ALTER TABLE social_flow 
ADD COLUMN post_length INT;

UPDATE social_flow
SET post_length = CHAR_LENGTH(message);