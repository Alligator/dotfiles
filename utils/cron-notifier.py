#!/usr/bin/env python3
# notify me on discord when a cron job fails
import mailbox
import requests

WEBHOOK_URL = 'WEBHOOK_URL_HERE'

discord_message = ''
for message in mailbox.mbox('/var/mail/alligator'):
    subject = message['subject']
    body = message.get_payload()
    discord_message += f'{subject}\n{body}\n'

if len(discord_message) > 0:
    content = f'<@DISCORD_USER_ID_HERE> cron job(s) failed: ```{discord_message}```'
    requests.post(WEBHOOK_URL, json={ 'content': content })
    open('/var/mail/alligator', 'w').close()
