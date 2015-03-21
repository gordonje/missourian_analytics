# missourian_analytics

Exploring and researching the Columbia Missourian's website analytics, social media and CMS data

Intro
-----

The [Columbia Missourian](http://www.columbiamissourian.com/) has a lot of data about itself: Data about how much traffic its web pages are getting, data about how much attention its articles are getting on Facebook and Twitter, and of course columbiamissourian.com sets atop a content management system (CMS) that stores every version of every article its ever published to the web.

So our quantitative research methods group got to wondering: What might all this data tell us? Granted, it's not exactly a laser-focused research question. Then again, if your trying to figure what research is both relevant and feasible, gathering together and exploring related datasets, is as good place as any to start.

Set up
------

We needed to put all relevant data that was potentially interesting to us in a single database so that it would be easier to run queries and statistical procedures. 

In terms of database managers, my current preference is for [PostgreSQL](http://www.postgresql.org/). If you prefer [MySQL](http://www.mysql.com/), that's fine. I'm not going argue with you (though, you won't have trouble finding folks who will). The sql scripts in this repo do use some syntax and functions that are Postgres-specific, so if you're trying to follow along with MySQL, you'll have to account for the differences yourself.

But really though: This is a speculative research project focused on a small city paper conducted by a bunch novices. For a class. I'm not anticipating a lot of followers.

Anyway, if you're on a Mac, I recommend installing Postgres via [Homebrew](http://brew.sh/). If you don't already have Homebrew, don't worry. It's free and easy to install. Note that this process will also require installing command line tools for Xcode. Just follow the instructions.

If you're on Windows or Linux...I don't know, man, just figure it out.

Once Postgres is installed and the server is running, then make the database (from the terminal):

	$ psql
	# CREATE DATABASE [db_name];
	# \q

While this repo includes several scripts for importing data, the raw data being imported is not included. For one thing, the files are rather large. Also, while the Missourian was nice enough to give us copies of whatever data they had, they did not give us (nor did we ask for) permission to pass it around to anybody. 

Regardless, if you did somehow get access to the files related to this project, they should go in the [data/](https://github.com/gordonje/missourian_analytics/tree/master/data) directory. Though, for some scripts, an absolute path to the file is required, so you'll have to make those changes where noted.

Importing Social Flow data
--------------------------

[Social Flow](http://www.socialflow.com/) is a service used by the Missourian to manage its Facebook and Twitter accounts. This includes posting messages and tracking the attention they garner in terms of likes, favorites, shares and comments. 

The Missourian was nice enough to grant us access to their Social Flow account. Once logged in, we were able to export a messages report that included a record for every Facebook and Twitter post by the Missourian's staff from Feb. 16, 2012 to Feb. 10, 2015. That's 23,131 Facebook and Twitter posts over the course of three years.

To import this data into Postgres, open your database client (e.g., Navicat), connect to new the database, then [create](https://github.com/gordonje/missourian_analytics/blob/master/create_social_flow.sql) and [load](https://github.com/gordonje/missourian_analytics/blob/master/sql/load_social_flow.sql) social flow data. This includes adding a serialized id field as a primary key.

Now with the data loaded, we can start to extract some additional info:

*	[post_length](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_post_len.sql): The number of characters in the message field, the most precise way of measuring message length.
* 	[word_count](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_word_count.sql): The number of words in the message field, which is a less precise (though perhaps more meaningful?) way of measuring message length.
*	[weekday](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_day_of_week.sql): The day of week when the message was published.
*	[hour_pubd](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_hour.sql): The hour of the day when the message was published.
* 	[has_question](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_questions.sql): Whether or not the message poses a question to the audience, which is a framing quality.
* 	[has_exclamation](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_exclamations.sql): Whether or not the message includes an exclamatory statement (i.e., ending in '!').
*	[has_graphic](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_graphic.sql): Whether or not the message includes a graphic, which is detemined by the inclusion of the word 'graphic', though we're trying to include only cases when it is is used as a noun and not as an adjective (as in "These photos are graphic").

We can also create some relational tables:

*	[hash_tags](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_hashtags.sql): Contains records of #hash_tags and the id of each message in which that #hash_tag is included. Using this table, we can also add a hash_tag_count column to the primary table.
*	[handles](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_handles.sql): Contains records of @handles and the id of each message in which that @handle is included. And again, we can add an at_tags_count column to the primary table.
*	[links](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_links.sql): Contains records of URLs and the id of each message in which that URL is included. Note that this includes not only the URLs found in the message field but also the URL in the link field (if there is one), as these are never the same. Also added a links_count column to the primary table.

Other columns we might consider adding:

*	has_photo: Whether or not the message includes a photo. Though, it seems difficult to determine when this is the case. We can easily find messages that contain the word "photo", but it's not obvious that all of these encompass all posts with a photo and excludes any that lack one.
*	~~sentences_count: The number of sentences, another way to measure the length of the message.~~(Seems like overkill).
*	has_quotes: Whether or not the message directly quotes a source for the story, another framing quality.

Importing CMS data
------------------

The Missourian was also nice enough to give us a copy of their CMS database, which included every version of every artcle ever filed in it as well as the section of the Missourian in which the article was filed. This is an important get for us, as it will control for some of the confounding factors related to differences in the kinds of articles the Missourian is promoting on Facebook and Twitter. Otherwise, we might end up treating sports and local government stories as equvalent.

The Missourian CMS is a MySQL database, so we can't import the source file directly into PostgreSQL. So we have to spin a MySQL server and create a new database:

	$ mysql -u root -p
	Enter password: <
	# CREATE DATABASE [db_name];
	# \q

Then import the source file:

	$ mysql -u root -p
	# CREATE DATABASE [db_name];
	# \q

Data caveats
------------

Your data is never as complete it might seem at first glance, and you've got to be honest with yourself (and your audience) regarding what exactly you've accounted for and what's missing. The "known unknowns", if you care to get all epistemological about it.

For example, the Social Flow message report data is not at all a complete picture of the attention Missourian articles have garnered on Facebook and Twitter. Rather, it merely accounts for the attention that content garnered via posts on the Missourian's official Facebook and Twitter accounts, which are run by the Missourian's social engagement team. No doubt there are plenty of other folks promoting Missourian content via their personal Facebook and Twitter accounts: Reporters, editors and photographers sharing their own work and that of their co-workers as well as audience members who may share links to whatever content they like. And the data we currently have doesn't tell us anything about those non-official social media posts and the attention they garnered.

