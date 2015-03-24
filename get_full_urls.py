from datetime import datetime
from getpass import getpass
from sys import argv
import psycopg2
import requests
from time import sleep
from urlparse import urlparse

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

for url in urls:

	sleep(2)

	print '    Short URL {}'.format(url)

	try:
		# try getting full_url from headers_location
		header_location = requests.head(url).headers['location']

		if urlparse(header_location).netloc == 'columbiamissourian.com':

			print 'Full URL: {}'.format(header_location)

			with psycopg2.connect(conn_string) as conn:
				with conn.cursor() as cur:
					cur.execute('''INSERT INTO short_to_full_urls (short_url, full_url)
									VALUES (%s, %s);''', (url, header_location)
								)
		else:

			print '     Trying re-direct...'

			sleep(2)

			response = requests.head(url, allow_redirects = True)

			print 'Full URL: {}'.format(response.url)

			with psycopg2.connect(conn_string) as conn:
				with conn.cursor() as cur:
					cur.execute('''INSERT INTO short_to_full_urls (short_url, full_url)
									VALUES (%s, %s);''', (url, response.url)
								)

	except requests.exceptions.InvalidURL:
		print '    Bad URL'

print "fin."
print '(Runtime = {0})'.format(datetime.now() - start_time)