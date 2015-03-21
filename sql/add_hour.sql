
ALTER TABLE social_flow 
ADD COLUMN hour_pubd INT;

UPDATE social_flow
SET hour_pubd = EXTRACT(h FROM time_utc);
