#!/usr/bin/env python

import sys
from SuperGLU.Services.CSVReader.CSVReader import CSVReader
from SuperGLU.Services.Recommenders.Recommender import Recommender,\
    RecommenderMessaging
from SuperGLU.Services.iCalReader.iCalReader import ICalReader
if sys.version_info < (3, 0):
    sys.stderr.write("Sorry, requires Python 3.4 or later\n")
    sys.exit(1)

import os
import traceback
import logging
import flask_socketio
import eventlet
import flask

from SuperGLU.Util.ErrorHandling import logError, logWarning
from flask import Flask
from Blueprints import BASIC_BLUEPRINT
from SuperGLU.Core.MessagingGateway import HTTPMessagingGateway
from SuperGLU.Core.Messaging import Message
from SuperGLU.Core.MessagingDB import DBLoggedMessage
from SuperGLU.Services.StudentModel.PersistentData import initDerivedDataTables,\
    DBSystem, DBTask, DBTopic, DBSession, DBStudent, DBClass, DBStudentModel,\
    DBClassModel, DBStudentAlias, DBClasssAlias, DBKCTaskAssociations,\
    DBAssistmentsItem
from SuperGLU.Services.LoggingService.LoggingService import (CSVLoggingService,
    DBLoggingService, IncomingMessage)
from SuperGLU.Services.StudentModel.StudentModel import StudentModelMessaging
from SuperGLU.Services.StorageService.GLUDBStorageService import GLUDBStorageService

from threading import Thread
from gludb.config import (Database, default_database, 
    clear_database_config, set_db_application_prefix)
from config import env_populate

APPLICATION_NAME = 'Recommender'
DEBUG_MODE = True
DEFAULT_PORT = 5533


eventlet.monkey_patch()

# Note that application as the main WSGI app is required for Python apps
# on Elastic Beanstalk. Also note that we provide the default config, but
# someone must supply an actual config file pointed to by the env variable
# APP_CONFIG_FILE. See ./local.sh for an example of how to handle this
application = Flask(__name__)
application.config.from_object('config.DefaultConfig')
application.config.from_envvar('APP_CONFIG_FILE')
application.secret_key = application.config.get('FLASK_SECRET')

# Set any environment var's requested by the config file
for name in env_populate:
    os.environ[name] = application.config.get(name)

# Final app settings depending on whether or not we are set for debug mode
if application.config.get('DEBUG', None):
    # Debug mode - running on a workstation
    application.debug = True
    logging.basicConfig(level=logging.DEBUG)
else:
    # We are running on AWS Elastic Beanstalk (or something like it)
    application.debug = False
    # See .ebextensions/01logging.config
    logging.basicConfig(
        filename='log/Re.log',
        level=logging.INFO
    )

APPLICATION_NAME = application.config.get('APPLICATION_NAME', 'noName')
    
logWarning('Application debug is %s'%(application.debug,))

# Register our blueprints
application.register_blueprint(BASIC_BLUEPRINT)

# Start up the messaging system
SOCKET_IO_CORE = flask_socketio.SocketIO(application)

#Allow some env specification of helpful test services
services = [DBLoggingService(), StudentModelMessaging(), GLUDBStorageService(),
            CSVReader(), RecommenderMessaging(), ICalReader()]

MESSAGING_GATEWAY = HTTPMessagingGateway(
        None,
        SOCKET_IO_CORE,
        flask_socketio,
        services
    )


# Message Handling
#-----------------------------
@SOCKET_IO_CORE.on('message', namespace='/messaging')
def receive_message(message):
    try:
        MESSAGING_GATEWAY.onReceiveAJAXMessage(message, flask.request.sid)     
    except Exception as err:
        if DEBUG_MODE:
            raise
        else:
            logError(err, stack=traceback.format_exc())

def background_thread():
    try:
        MESSAGING_GATEWAY.processQueuedMessages()
    except Exception as err:
        #if DEBUG_MODE:
        #    raise
        #else:
        logError(err, stack=traceback.format_exc())
        MESSAGING_GATEWAY.processQueuedMessages()

            
def StartServer(app=None, socketio=None, host=None, port=DEFAULT_PORT, debug=True):
    if socketio is None: socketio = SOCKET_IO_CORE
    if host is None:
        if debug:
            host = '0.0.0.0'
        else:
            host = '127.0.0.1'
    Thread(target=background_thread).start()
    logWarning("Starting Socket App1")
    try:
        logWarning(host)
        logWarning(port)
        socketio.run(app, host=host, port=port)
    except Exception as err:
        logError("Error: Could not start socketio.")
        DB_CONNECTION.close()
        
# Connection Monitoring
#------------------------------
@SOCKET_IO_CORE.on('connect', namespace='/messaging')
def onConnect():
    logWarning("Connected")
    #flask.ext.socketio.emit('my response', {'data': 'Connected', 'count': 0})

@SOCKET_IO_CORE.on('disconnect', namespace='/messaging')
def onDisconnect():
    logWarning('Client disconnected')

# This will be called before the first request is ever serviced
@application.before_first_request
def before_first():
    logWarning('Handling database init')
    if application.debug:
        # Debug/local dev
        logWarning('Debug Mode: MongoDB')
        default_database(Database( 'mongodb', mongo_url='mongodb://localhost:27017/TestDB'))
    else:
        # Production!
       logWarning('Production Mode: MongoDB')
       default_database(Database( 'mongodb', mongo_url='mongodb://localhost:27017/TestDB'))
    set_db_application_prefix(APPLICATION_NAME)

    # Make sure we have our tables
    #IncomingMessage.ensure_table()
    initDerivedDataTables()
    #Transcript.ensure_table()
    #Taxonomy.ensure_table()


# Our entry point - called when our application is started "locally".
# This WILL NOT be run by Elastic Beanstalk
def main():
    # Listen on all addresses if running under Vagrant, else listen
    # on localhost
    StartServer(application, SOCKET_IO_CORE, None, DEFAULT_PORT)
if __name__ == '__main__':
    main()
