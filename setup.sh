#!/bin/bash

# Symbolic Link to the SuperGLU and GLUDB Repos
cd ..
sudo ln -s ./SuperGLURepo/SuperGLU/ ./Application/
sudo ln -s ./GLUDBRepo/gludb/ ./Application/

# Populate static files
mkdir ./Application/log/
echo 'Started the log file.' > ./Application/log/Re.log
mkdir ./Application/static/SuperGLU/
sudo chmod 755 ./Application/static/SuperGLU/
sudo rsync -a --prune-empty-dirs --include '*/' --include '*.js' --exclude '*' ./Application/SuperGLURepo/SuperGLU ./Applicatio$

# Make sure we're in our script directory
cd ./Application/
ls -l
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

# Set up a virtual environment using python3, use the new environment, and
# install our dependencies
#virtualenv -p python3 env --always-copy
python3 -m venv env --copies

source $SCRIPT_DIR/env/bin/activate


sudo apt-get install python3-pip

pip3 --version

#pip install --upgrade requests[security]
pip3 install -U pip3
pip3 install Flask
pip3 install flask-socketio==1.1
pip3 install pymongo
pip3 install boto
pip3 install eventlet
pip3 install json_delta
pip3 install icalendar
# pip install gludb
# pip install SuperGLU