ALTER TABLE social_flow
ADD COLUMN has_question BOOLEAN DEFAULT FALSE;

UPDATE social_flow
SET has_question = TRUE
WHERE message LIKE '%?%';
