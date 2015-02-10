# missourian_analytics
A repo for investigating web and social media analytics collected by the Columbia Missourian.

For starters, we need to set up a local PostgreSQL database:

Then open a database client (e.g., Navicat), connect to the database, then [create](https://github.com/gordonje/missourian_analytics.git/blob/master/create_social_flow.sql) and [load](https://github.com/gordonje/missourian_analytics.git/blob/master/load_social_flow.sql) social flow data.

Now we're ready to start adding columns and setting their values:

*	[post_length](https://github.com/gordonje/missourian_analytics.git/blob/master/add_post_len.sql): The number of characters in the message field, which is the most precise way of measuring message length.
* 	[word_count](https://github.com/gordonje/missourian_analytics.git/blob/master/add_word_count.sql): The number of words in the message field, which is a less precise (though perhaps more meaningful?) way of measuring message length.
*	[weekday](https://github.com/gordonje/missourian_analytics.git/blob/master/add_day_of_week.sql): The day of week when the message was posted.

Other columns we might consider adding:

*	sentences_count: The number of sentences, another way to measure the length of the message.
*	has_question: Whether or not the message poses a question to the audience, which is a framing quality.
*	has_quotes: Whether or not the message directly quotes a source for the story, another framing quality.
*	has_photo: Whether or not the message includes a photo.
*	has_graphic: Whether or not the message includes a graphic.
*	is_link_package: Whether or not the message contains multiple links to different stories.
