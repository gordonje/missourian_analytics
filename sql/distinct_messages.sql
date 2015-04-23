-- There are 37 distinct messages that were posted between 2 and 4 times
SELECT message, COUNT(*)
FROM social_flow
GROUP BY message
HAVING COUNT(*) > 1
ORDER BY 2 DESC;

-- It appears as though the dates vary on these
SELECT *
FROM social_flow
WHERE message = 'What have you always wanted to know about Columbia, but never knew who to ask? Ask us anything about CoMo culture, infrastructure, education and more. Comment or email your questions to submissions@ColumbiaMissourian.com and let us work for you!'
