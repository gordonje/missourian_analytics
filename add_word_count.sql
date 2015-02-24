
ALTER TABLE social_flow 
ADD COLUMN word_count INT;

UPDATE social_flow
SET word_count = (
    select count(*)
    from (select unnest(regexp_matches(message, E'\\w+','g'))) s
    );

-- alternate method of doing word count
-- UPDATE social_flow
-- SET word_count = array_length(regexp_split_to_array(message, E'\\s+'), 1);

-- select message, word_count, word_count2 
-- from social_flow 
-- where word_count <> word_count2
-- order by word_count DESC;