
ALTER TABLE social_flow
ADD COLUMN has_exclamation BOOLEAN DEFAULT FALSE;

UPDATE social_flow
SET has_exclamation = TRUE
WHERE message LIKE '%!%';

