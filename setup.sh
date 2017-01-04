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
sudo rsync -a --prune-empty-dirs --include '*/' --include '*.js' --exclude '*' ./Application/SuperGLURepo/SuperGLU ./Application/static/

# Make sure we're in our script directory
cd ./Application/
ls -l
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

# Set up a virtual environment using python3, use the new environment, and
# install our dependencies
#virtualenv -p python3 env --always-copy

sudo apt-get install -y curl
sudo apt-get install -y python3-pip
sudo curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo python3

python3 -m venv env --copies
source $SCRIPT_DIR/env/bin/activate
pip3 --version

#pip install --upgrade requests[security]
#sudo python3 -m pip install -U pip3
#sudo python3 -m pip install Flask
#sudo python3 -m pip install flask-socketio==1.1
#sudo python3 -m pip install pymongo
#sudo python3 -m pip install boto
#sudo python3 -m pip install eventlet
#sudo python3 -m pip install json_delta
#sudo python3 -m pip install icalendar
pip3 install -U pip3
pip3 install Flask
pip3 install flask-socketio==1.1
pip3 install pymongo
pip3 install boto
pip3 install eventlet
pip3 install json_delta
pip3 install icalendar
pip3 install stomp.py
# pip install gludb
# pip install SuperGLU