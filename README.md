# missourian_analytics

Exploring and researching the Columbia Missourian's website analytics, social media and CMS data

Intro
-----

The [Columbia Missourian](http://www.columbiamissourian.com/) has a lot of data about itself: Data about the traffic on its web pages, data about the attention its posts are getting on Facebook and Twitter, and of course columbiamissourian.com sits atop a content management system (CMS) with a database that stores every version of every article its ever published to the web.

So our quantitative research methods group got to wondering: What might all these data tell us? Granted, it's not exactly a laser-focused research question. Then again, if you're trying to figure what research is both relevant and feasible, gathering together and exploring related data sets is as good place as any to start.

Set up
------

We needed to put all relevant and potentially interesting data into a single database in order to run queries and statistical procedures. My personal preference is to use [PostgreSQL](http://www.postgresql.org/). If you're following along while using a different database manager (e.g., [MySQL](http://www.mysql.com/), [SQL Server](http://www.microsoft.com/en-us/server-cloud/products/sql-server/), etc.), then you'll need to account for some syntactical of functional differences on your own.

But really though: This is a speculative research project focused on a small city paper conducted by a bunch of novices. For a class. I'm not anticipating a lot of followers.

Anyway, if you're on a Mac, I recommend installing Postgres via [Homebrew](http://brew.sh/). If you don't already have Homebrew, don't worry. It's free and easy to install. Note that this process will also require installing command line tools for Xcode. Just follow the Homebrew installation instructions, then run `brew install mysql`.

If you're on Windows or Linux...I don't know, man, just figure it out.

Once Postgres is installed and the server is running, then make the database (from the terminal):

	$ psql
	# CREATE DATABASE [db_name];
	# \q

While this repo includes several scripts for importing data, the raw data being imported is not included. For one thing, the files are rather large. Also, while the Missourian was nice enough to give us copies of whatever data they had, they did not give us (nor did we ask for) permission to pass it around to anybody. 

Regardless, if you somehow got hold of the files related to this project, they should go in the [data/](https://github.com/gordonje/missourian_analytics/tree/master/data) directory. For some scripts, an absolute path to the file is required, so you'll have to make those changes where noted.

Importing Social Flow data
--------------------------

[Social Flow](http://www.socialflow.com/) is a service used by the Missourian to manage its Facebook and Twitter accounts. This includes posting messages and tracking the attention they garner in terms of likes, favorites, shares and comments. 

The Missourian graciously gave us credentials to their Social Flow account, so once logged in, we exported what's called a "messages report" which includes a record for every Facebook and Twitter post by the Missourian's staff from Feb. 16, 2012 to Feb. 10, 2015. That's 23,131 Facebook and Twitter posts over the course of three years.

To import the data into Postgres, open your database client (e.g., Navicat), connect to new the database, then [create](https://github.com/gordonje/missourian_analytics/blob/master/create_social_flow.sql) and [load](https://github.com/gordonje/missourian_analytics/blob/master/sql/load_social_flow.sql) social flow data. This includes adding a serialized id field as a primary key.

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
*	[links](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_links.sql): Contains records of URLs and the id of each message in which that URL is included. Note that this includes not only the URLs found in the message field but also the URL in the link field (if there is one), as these are never the same. We also added a links_count column to the primary table.

We should also add [some indexes](https://github.com/gordonje/missourian_analytics/blob/master/sql/index_social_flow_data.sql) to many of these columns so that our queries will run a little faster.

Other columns we might consider adding:

*	has_photo: Whether or not the message includes a photo. Though, it seems difficult to determine when this is the case. We can easily find messages that contain the word "photo", but it's not obvious that all of these encompass all posts with a photo and excludes any that lack one.
*	~~sentences_count: The number of sentences, another way to measure the length of the message.~~(Seems like overkill).
*	has_quotes: Whether or not the message directly quotes a source for the story, another framing quality.

Importing CMS data
------------------

The Social Flow message report tells us what content the Missourian has promoted on Facebook and Twitter, but we want to know more about each individual piece of content. As our quant methods professor pointed out to us, any analysis we want to perform might need to control for confounding factors related to differences in the kinds of articles the Missourian is promoting on Facebook and Twitter. Otherwise, we would be treating sports and local government stories as equivalent.

Thankfully, the Missourian was also nice enough to give us a copy of their CMS database, which includes every version of every article ever filed as well as the section of the Missourian in which the article was filed.

This CMS is built in [Django](https://www.djangoproject.com/) with a a MySQL backend. Attempts to import the .sql file directly into Postgres failed miserably (not all that shocking), so we had to do a little extra work. Still worth it so as to get to pull things together into Postgres.

We have to spin up a MySQL server. If you don't already have MySQL, Mac folks, again use Homebrew (everyone else figure it out). And even if you already have MySQL, you should first make sure everything is up-to-date. Run `brew doctor` then `brew update` then `brew upgrade mysql`. You might need to run this last command more than once, as I did, in order to get to the latest version.

Then you need to start the MySQL server. Though, this step gave us a bit of trouble:

	$ mysql.server start
	Starting MySQL..
	. ERROR! The server quit without updating PID file (/usr/local/some/path/[something that looks like a URL].pid).

Super annoying. But a little Googling and we came across [a couple](http://coolestguidesontheplanet.com/mysql-error-server-quit-without-updating-pid-file/) [of posts](http://www.mahdiyusuf.com/post/21022913180/mysql-the-server-quit-without-updating-pid-file) describing the same issue and an easy fix. Just remove these .err files like so `rm *.err /path/to/file/data/mentioned_in_previous_error` then start the server for real this time `mysql.server start`.

Then, create a MySQL database:

	$ mysql -u root -p
	Enter password:
	# CREATE DATABASE [db_name];
	# \q

Then import the CMS data file:

	$ mysql -u root -p [cms database name] < /path/to/this_file/missouriandb.sql

Now we can explore the CMS data a bit more:

*	There were [107,422 articles](https://github.com/gordonje/missourian_analytics/blob/master/sql/prelim_cms_checks.sql#L1-L3) published between [July 2002](https://github.com/gordonje/missourian_analytics/blob/master/sql/prelim_cms_checks.sql#L5-L9) and...[apparently December 2020](https://github.com/gordonje/missourian_analytics/blob/master/sql/prelim_cms_checks.sql#L11-L15). Seems like a bug, but one that [affected only 13 articles](https://github.com/gordonje/missourian_analytics/blob/master/sql/prelim_cms_checks.sql#L17-L20).
*	Most articles are filed in [at least one section](https://github.com/gordonje/missourian_analytics/blob/master/sql/prelim_cms_checks.sql#L29-L37) of the Missourian. Only 379 were not.
*	Half of the articles were [filed in multiple sections](https://github.com/gordonje/missourian_analytics/blob/master/sql/prelim_cms_checks.sql#L39-L46). Only one article was filed in eight section. Apparently, [when there's a Harry Potter movie opening](http://www.columbiamissourian.com/a/116132/harry-potter-fans-flock-to-columbia-for-midnight-movie-release/), everybody wants a piece.
*	We can also [get the proportion of articles](https://github.com/gordonje/missourian_analytics/blob/master/sql/prelim_cms_checks.sql#L39-L46) filed in each section. Here are the top one:
	*	Local 36.12 %
	*	News 28.8 %
	*	State News 16.83 %
	*	Sports	13.77 %
	*	Other Sports 12.57 %
	*	Opinion 4.76 %
	*	Higher Education 3.84 %

But since we're combining these CMS data with the Social Flow data, we should restrict our exploration to the window of time where they overlap:
*	Between Feb. 16, 2012, and Feb. 10, 2015, the Missourian [published 38,146 articles](https://github.com/gordonje/missourian_analytics/blob/master/sql/within_time_window_checks.sql#L1-L5).
*	Still, [half](https://github.com/gordonje/missourian_analytics/blob/master/sql/within_time_window_checks.sql#L7-L18) of them were filed in multiple sections, as many as [six](https://github.com/gordonje/missourian_analytics/blob/master/sql/within_time_window_checks.sql#L7-L18).
*	And here are the [proportions](https://github.com/gordonje/missourian_analytics/blob/master/sql/within_time_window_checks.sql#L7-L18) for article sections:
	*	News 32 %
	*	Sports 24.72 %
	*	Local 24 %
	*	State News 18.35 %
	*	Pro Sports 8.6 %
	*	Mizzou Sports 7.52 %
	*	Opinion 6.14 %

So now we can grab the goods and head back over to Postgres:

*	[This query](https://github.com/gordonje/missourian_analytics/blob/master/sql/export_from_cms.sql) will create a .csv file containing a record of each section in which each article has been filed.
*	Switch back to Postgres and run [these queries](https://github.com/gordonje/missourian_analytics/blob/master/sql/import_cms_data.sql) in order to import this file into Postgres.
*	And, for good measure, let's add some [more indexes](https://github.com/gordonje/missourian_analytics/blob/master/sql/index_articles_sections.sql).

URL Lengthening
---------------

The links included in the Facebook and Twitter posts, of course, point to Missourian content. That's how we can figure out how much social media attention each individual piece of content received.

But there's a major problem: [60 percent](https://github.com/gordonje/missourian_analytics/blob/master/sql/check_links.sql) of URLs found in the Missourian's Social Flow messages aren't direct links to columbiamissourian.com. Most of these are URLs shortened via services like [bit.ly](https://bitly.com/).

Are we going to let a snag like this stand in the way of our important, ground-breaking research? Hell no! So we wrote a [Python script](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py) that requests each shortened URL and collects the full_url to which it re-directs. 

First, we need to install some Python libraries to help us get the job done. If you're using a Mac, you might want to follow best practices and set up virtual environment (I use [virtualenv](https://virtualenv.pypa.io/en/latest/) along with [virtualenvwrapper](https://virtualenvwrapper.readthedocs.org/en/latest/)). Then `pip install requests` (for handling HTTP requests) and `pip install psycog2` (for connecting to our Postgres database).

Here's how get_full_urls.py works:

1.	Set up [database connection parameters](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L54-L70).

2.	[Create](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L78) the `short_to_full_urls` table (if it doesn't already exist).

3.	[Select](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L80) the distinct shortened URLs and [append each one](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L39-L41) to a pre-defined variable.

4.	For each shortened URL, call [get_full_url()](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L100), which is a recursive function that does the following:
	*	[Make a HEAD request](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L14).

	*	As long as requests doesn't throw one of several [exceptions](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L37-L47) or we don't get a [bad status code](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L16-L19), then we get the [re-direct location](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L22-L23) out of the response's header.

	*	If the re-direct URL [doesn't include](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L25-L26) the domain of a URL-shortening service (i.e., bit.ly, trib.al, ow.ly, t.co), then we return that URL along with the number of re-directs. [Otherwise](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L28-L31), we call get_full_url() again, this time with the re-direct URL.

		This is necessary because, as it turns out, a lot of these shortened URLs point to other shortened URLs. For example, you'll see a bit.ly URL that re-directs to a trib.al URL which then re-directs to columbiamissourian.com page. Which is...really odd. Even weirder, sometimes the second URL re-directs to *yet another* shortened URL. We've found re-direct chains with as many as *eight shortened URLs*---bit.ly to trib.al to *yet another* bit.ly URL to *yet another* trib.al URL and back and forth again---before eventually landing on a columbiamissourian.com page.

		Not sure what that's all about.
5.	Finally, we [save](https://github.com/gordonje/missourian_analytics/blob/master/get_full_urls.py#L108-L133) whichever non-shortened-URL we find, along with the URL components and the number of re-directs.

It's great that we can get away with making only HEAD requests because they don't include all of the content which comes with a GET request. Which means this script can run a little faster than a typical scraper. But for the sake of being extra kind to the web servers, we added a one second delay between requests. Since we're requesting roughly 20k URLs with an average of two re-directs for each, **the script has to run for 11 to 12 hours**. 

Once we have all of the full URLs, we need line them up next to each message that points contains. Remember the `messages_links` table? We [add]() a few more columns to that and [populate them with the data we've just scraped](). But don't forget about all those links that were never shortened in the first place. For these we wrote [parse_urls.py]() which, as the name suggests, parses each URL into its components (e.g., the network location and path).

All Together Now
----------------

We how have the full URL of each link included in each Missourian social media post. What comes next is lining these records up with each artcile from the CMS. And luckily the article_id and slug from the CMS are embedded in the URL to article. So for http://www.columbiamissourian.com/a/145793/temporary-lane-closure-on-eighth-street-begins-monday/, the article_id is **145793** and the slug is **temporary-lane-closure-on-eighth-street-begins-monday**. 

The **a** in the previous URL indicates that the link points to an article, represented in the CMS as a `core_article` row. In the same position in the URL, a **p** would point instead toward a specific page (a `core_page` row), for example, http://www.columbiamissourian.com/p/2012-primary-election/.

At this point, we're deciding to focus solely on the articles since these are the most prevalent content types the Missourian shares on social media and seemingly the only type that is classifed into sections.

So now we will [add](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_and_set_a_ids.sql#L2-L4) an `article_id` field and [populate](https://github.com/gordonje/missourian_analytics/blob/master/sql/add_and_set_a_ids.sql#L6-L9) it for all links that contain '/a/'. 

By this point, you might have noticed another URL format, where the path begins with '/stories/'. These are links to artciles as well, but do not include the article_id. 

Ugh. But let's keep on trucking. We can use the slug and date portions of the URL path as join criteria [like so](https://github.com/gordonje/missourian_analytics/blob/master/sql/set_article_ids_for_stories.sql).

We now have [11,494 distinct articles](https://github.com/gordonje/missourian_analytics/blob/master/sql/message_links_articles_checks.sql#L7-L9) shared in [18,999 distinct messages](https://github.com/gordonje/missourian_analytics/blob/master/sql/message_links_articles_checks.sql#L11-L14). Each article was [shared an average of 2.84 times](https://github.com/gordonje/missourian_analytics/blob/master/sql/message_links_articles_checks.sql#L16-L23).


Data caveats
------------

Your data are never as complete they seem at first glance, and you've got to be honest with yourself (and your audience) regarding what exactly is accounted for and what's missing. The "known unknowns", if you care to get all epistemological about it.

For example, the Social Flow message report data is not at all a complete picture of the attention Missourian content has garnered on Facebook and Twitter. Rather, it merely accounts for how much attention was paid to posts on the Missourian's official Facebook and Twitter accounts, which are run by the Missourian's social engagement team. No doubt there are plenty of other folks promoting Missourian content via their personal Facebook and Twitter accounts: Reporters, editors and photographers sharing their own work and their co-workers' work as well as audience members who may share links to whatever content they like. 

The data we currently have doesn't tell us anything about those non-official social media posts and the attention they received.

