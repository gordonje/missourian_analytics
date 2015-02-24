# missourian_analytics
A repo for investigating web and social media analytics collected by the Columbia Missourian.

-----------------

For starters, we need to set up a local PostgreSQL database from the command line:

	$ psql
	# CREATE DATABASE [db_name];
	# \q

Then open a database client (e.g., Navicat), connect to new the database, then [create](https://github.com/gordonje/missourian_analytics/blob/master/create_social_flow.sql) and [load](https://github.com/gordonje/missourian_analytics/blob/master/load_social_flow.sql) social flow data. This includes adding a serialized id field as a primary key.

Now we're ready to start adding columns and setting their values:

*	[post_length](https://github.com/gordonje/missourian_analytics/blob/master/add_post_len.sql): The number of characters in the message field, the most precise way of measuring message length.
* 	[word_count](https://github.com/gordonje/missourian_analytics/blob/master/add_word_count.sql): The number of words in the message field, which is a less precise (though perhaps more meaningful?) way of measuring message length.
*	[weekday](https://github.com/gordonje/missourian_analytics/blob/master/add_day_of_week.sql): The day of week when the message was posted.
* 	[has_question](https://github.com/gordonje/missourian_analytics/blob/master/add_questions.sql): Whether or not the message poses a question to the audience, which is a framing quality.

We can also create some relational tables:

*	[hash_tags](https://github.com/gordonje/missourian_analytics/blob/master/add_hash_tags.sql): Contains records of #hash_tags and the id of each message in which that #hash_tag is included. Using this table, we can also add a hash_tag_count column to the primary table.
*	[handles](https://github.com/gordonje/missourian_analytics/blob/master/add_handles.sql): Contains records of @handles and the id of each message in which that at_tag is included. And again, we can add an at_tags_count column to the primary table.

Other columns we might consider adding:

*	sentences_count: The number of sentences, another way to measure the length of the message.
*	has_quotes: Whether or not the message directly quotes a source for the story, another framing quality.
*	has_photo: Whether or not the message includes a photo.
*	has_graphic: Whether or not the message includes a graphic.
*	is_link_package: Whether or not the message contains multiple links to different stories.
