
ALTER TABLE social_flow
ADD COLUMN has_graphic BOOLEAN DEFAULT FALSE;

UPDATE social_flow
SET has_graphic = TRUE
WHERE message ~* '\mgraphic\M'
AND message !~* '(is graphic|were graphic|be graphic|are graphic)';
