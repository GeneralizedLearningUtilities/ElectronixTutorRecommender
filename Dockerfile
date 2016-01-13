FROM ubuntu:14.04

RUN sudo apt-get -y update && sudo apt-get -y upgrade

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
RUN easy_install pip
RUN pip install virtualenv

RUN sudo apt-get -y update && sudo apt-get -y upgrade

# Install app
ADD . ./Application
ADD ./config/boto.cfg /etc/boto.cfg

#configure nginx
RUN sudo rm /etc/nginx/sites-enabled/default
RUN sudo ln -s ./Application/config/recommender.x-in-y.conf /etc/nginx/conf.d/
RUN sudo /etc/init.d/nginx restart

# Install dependencies
RUN bash ./Application/setup.sh
RUN bash ./Application/setup-ec2.sh

RUN chmod +x ./Application/local.sh

EXPOSE 80
EXPOSE 443
#EXPOSE 5533

# TODO: Path unlikely to be correct...
CMD ["bash", "/Application/local.sh"]
