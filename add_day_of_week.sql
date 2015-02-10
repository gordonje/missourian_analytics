ALTER TABLE social_flow 
ADD COLUMN day_of_week INT;

UPDATE social_flow
SET day_of_week = EXTRACT(dow FROM publish_date);

