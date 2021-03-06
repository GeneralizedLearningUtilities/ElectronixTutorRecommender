FROM ubuntu:14.04

# MongoDB Installation:
# Import MongoDB public GPG key AND create a MongoDB list file
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN sudo echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
# Create the MongoDB data directory
RUN mkdir -p /data/db


RUN sudo apt-get -y update && sudo apt-get -y upgrade


RUN sudo apt-get -y install mongodb-org
RUN sudo apt-get -y install git
RUN sudo apt-get -y install software-properties-common
RUN sudo add-apt-repository ppa:nginx/stable
RUN sudo apt-get -y install nginx

# Install Python Frameworks + GCC
RUN sudo apt-get -y install gcc
RUN sudo apt-get -y install python3
RUN sudo apt-get -y install python-dev
RUN sudo apt-get -y install python3-dev
RUN sudo apt-get -y install libevent-dev
RUN sudo apt-get install -qy python-setuptools
RUN sudo apt-get -y install python3.4-venv
RUN sudo easy_install pip
RUN sudo pip install --upgrade pip
RUN sudo pip install virtualenv
RUN sudo pip install awscli

# Configure nginx
RUN sudo rm /etc/nginx/sites-enabled/default
RUN sudo ln -s /Application/config/recommender.x-in-y.conf /etc/nginx/conf.d/
RUN sudo apt-get -y update && sudo apt-get -y upgrade

# Copy SSL Certificates
RUN sudo aws s3 cp s3://s3-oregon-zone-specialkeys-for-et/unified-wildcard.x-in-y.crt /etc/ssl/unified-wildcard.x-in-y.crt;
RUN sudo aws s3 cp s3://s3-oregon-zone-specialkeys-for-et/wildcard.x-in-y.key /etc/ssl/wildcard.x-in-y.key

# Install app
ADD . ./Application/
#ADD ./config/boto.cfg /etc/boto.cfg
ADD ./prod.config ./Application/server.config

# Install dependencies
WORKDIR ./Application/
RUN bash setup.sh
RUN bash setup-ec2.sh
RUN chmod +x local.sh
WORKDIR /

EXPOSE 80
EXPOSE 443
EXPOSE 27017
#EXPOSE 5533
RUN sudo /etc/init.d/nginx restart

# TODO: Path unlikely to be correct...
CMD ["bash", "/Application/local.sh"]
