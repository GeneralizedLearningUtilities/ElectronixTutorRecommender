#!/bin/bash

# Make sure we're in our script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

# Install Python Frameworks + GCC
sudo apt-get -y install gcc
sudo apt-get -y install python3
sudo apt-get -y install python-dev
sudo apt-get -y install python3-dev
sudo apt-get -y install libevent-dev
sudo apt-get install -qy python-setuptools
easy_install pip
pip install virtualenv

# Set up a virtual environment using python3, use the new environment, and
# install our dependencies
virtualenv -p python3 env --always-copy
source $SCRIPT_DIR/env/bin/activate
#pip install --upgrade requests[security]
pip install gludb
pip install Flask
pip install flask-socketio==1.1
pip install pymongo
pip install boto
pip install eventlet
# pip install SuperGLU

# Symbolic Link to the SuperGLU Repository
ln -s SuperGLURepo/SuperGLU SuperGLU

# Populate static files
mkdir static/SuperGLU
rsync -a --prune-empty-dirs --include '*/' --include '*.js' --exclude '*' SuperGLURepo/SuperGLU/ static/SuperGLU/