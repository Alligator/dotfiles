#!/usr/bin/env python3
# read nginx logs from stdin and write them to logs.db, a sqlite database.
# it will create the db if it doesn't exist.
#
# useful when combined with zcat to read gzipped logs:
#   zcat /var/log/nginx/access.log.*.gz | ./parse-nginx-logs.py

import sys
import re
import fileinput
import sqlite3
from datetime import datetime
from pprint import pprint

# stand in for sys.stdin
# inp = '162.158.158.79 - - [17/Nov/2019:06:52:02 +0000] "GET /robots.txt HTTP/1.1" 200 31 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"\n131.221.194.10 - - [25/Nov/2019:03:31:18 +0000] "GET / HTTP/1.1" 200 446 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"'

def parse_date_format(d):
    return datetime.strptime(d, '%d/%b/%Y:%H:%M:%S %z').isoformat()

def parse_line(line):
    regex = r'^(?P<ip>\S+) \S+ \S+ \[(?P<date>[^\]]+)\]'\
    + ' "(?P<method>[A-Z]+) (?P<request>[^ "]+)[^"]*"'\
    + ' \d+ \d+ "(?P<referer>[^"]+)" "?(?P<ua>[^"]+)?"'
    match = re.match(regex, line)
    if match == None:
        return None
    d = match.groupdict()
    d['date'] = parse_date_format(match.groupdict()['date'])
    d['request'] = d['request'].replace('\'', '')
    d['ua'] = d['ua'].replace('\'', '')
    return d

print("connecting to db")
conn = sqlite3.connect('logs.db')
c = conn.cursor()
print("creating logs table")
c.execute('CREATE TABLE IF NOT EXISTS logs(ip, date, method, request, referer, ua)')
c.execute('CREATE INDEX IF NOT EXISTS ix_logs ON logs(date)')
c.execute('BEGIN TRANSACTION')
i = 0
print("parsing logs")
for line in fileinput.input():
    if i % 100 == 0:
        sys.stdout.write('\r           ')
        sys.stdout.write('\r' + str(i))
    result = parse_line(line)
    if result != None:
        c.execute(
            'INSERT INTO logs(ip, date, method, request, referer, ua) VALUES (?, ?, ?, ?, ?, ?)',
            (result['ip'], result['date'], result['method'], result['request'], result['referer'], result['ua']),
        )
    i += 1
c.execute('COMMIT')
