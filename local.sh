#!/bin/bash

sudo service nginx start
sudo service /usr/bin/mongod start

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

# Use our virtual environment and run the application in DEBUG mode with our
# test config file. Note that the test config file IS NOT in version control
source $SCRIPT_DIR/env/bin/activate
export APP_CONFIG_FILE=$SCRIPT_DIR/server.config
python3 $SCRIPT_DIR/application.py