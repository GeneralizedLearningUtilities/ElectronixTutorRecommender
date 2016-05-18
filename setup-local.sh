sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

sudo apt-get -y upgrade
sudo apt-get -y update
sudo apt-get -y install mongodb-org
sudo apt-get -y install gcc
sudo apt-get -y install python3
sudo apt-get -y install python-dev
sudo apt-get -y install python3-dev
sudo apt-get -y install libevent-dev
sudo apt-get -y install python3.4-venv
sudo apt-get install -qy python-setuptools
sudo easy_install pip
sudo pip install --upgrade pip
sudo pip install virtualenv

sudo service mongod start

sudo ln -s ./test.config ./server.config
# sudo ln -s ../SuperGLU/SuperGLU ./SuperGLU
# sudo ln -s ../GLUDB/gludb ./gludb
# sudo ln -s ../icalendar/src/icalendar ./icalendar
sudo sh setup.sh