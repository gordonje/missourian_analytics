from datetime import datetime
from getpass import getpass
from sys import argv
import psycopg2
import psycopg2.extras
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

rows = []

row_count = 0

with psycopg2.connect(conn_string) as conn:
	with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
		cur.execute(open('sql/select_urls_to_parse.sql', 'r').read())

		for row in cur.fetchall():
			rows.append(row)

		for row in rows:
			cur.execute('''UPDATE messages_links
							SET full_link = %s,
								scheme = %s,
								netloc = %s,
								url_path = %s,
								params = %s,
								query = %s,
								fragment = %s
							WHERE message_id = %s
							AND link = %s;'''
						, (
							  row['link']
							, urlparse(row['link']).scheme
							, urlparse(row['link']).netloc
							, urlparse(row['link']).path
							, urlparse(row['link']).params
							, urlparse(row['link']).query
							, urlparse(row['link']).fragment
							, row['message_id']
							, row['link']
						)	
					)

			row_count += 1

			print 'Row number {}'.format(row_count)

