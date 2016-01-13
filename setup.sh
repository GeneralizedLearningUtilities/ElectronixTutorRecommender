#!/bin/bash

# Symbolic Link to the SuperGLU Repository
ls -l
ls -d $PWD/*
sudo ln -s  SuperGLURepo/SuperGLU/ SuperGLU/

# Populate static files
sudo mkdir static/SuperGLU/
sudo rsync -a --prune-empty-dirs --include '*/' --include '*.js' --exclude '*' SuperGLURepo/SuperGLU/ static/SuperGLU/

# Make sure we're in our script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

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
