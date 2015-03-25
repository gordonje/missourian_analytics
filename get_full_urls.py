from datetime import datetime
from getpass import getpass
from sys import argv
import psycopg2
import requests
from time import sleep
from urlparse import urlparse

def get_full_url (url):

	sleep(1.5)

	try:
		response = requests.head(url)

		try:
			header_location = response.headers['location']

			if urlparse(header_location).netloc == 'www.columbiamissourian.com':
				return header_location

			else:
				print "    {} isn't right. Trying re-direct...".format(header_location)
				return get_full_url(header_location)

		except requests.exceptions.ConnectionError as conn_error:
			print conn_error
		
		except requests.exceptions.Timeout as timeout_error:
			print timeout_error

		except KeyError:
			print '    Bad URL'

	except requests.exceptions.InvalidURL as url_error:
		print url_error


start_time = datetime.now()
print 'Started at {}'.format(start_time)


# connect to the database, prompt if not provided
try:
	db = argv[1]
except IndexError:
	db = raw_input("Enter db name:")

try:
	user = argv[2]
except IndexError:
	user = raw_input("Enter db user:")

try:
	password = argv[3]
except IndexError:
	password = getpass("Enter db password:")

conn_string = "dbname=%(db)s user=%(user)s password=%(password)s" % {"db": db, "user": user, "password": password}


urls = []

with psycopg2.connect(conn_string) as conn:
	with conn.cursor() as cur:
		
		cur.execute(open('sql/create_short_to_full_urls.sql', 'r').read())

		cur.execute(open('sql/select_short_urls.sql', 'r').read())

		for url in cur.fetchall():

			urls.append(url[0])


with requests.session() as session:

	session.headers.update(
		{
			'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
		}
	)

	for url in urls:

		print '    Short URL: {}'.format(url)

		full_url = get_full_url(url)

		print '    Full URL: {}'.format(full_url)

		with psycopg2.connect(conn_string) as conn:
			with conn.cursor() as cur:
				cur.execute('''INSERT INTO short_to_full_urls (short_url, full_url)
								VALUES (%s, %s);''', (url, full_url)
							)

		print '------------------'

print "fin."
print '(Runtime = {0})'.format(datetime.now() - start_time)

