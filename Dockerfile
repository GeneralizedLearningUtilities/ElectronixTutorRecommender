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

#configure nginx
RUN sudo rm /etc/nginx/sites-enabled/default
RUN sudo ln -s ./Application/config/recommender.x-in-y.conf /etc/nginx/conf.d/
RUN sudo apt-get -y update && sudo apt-get -y upgrade

# Install app
ADD . ./Application/
ADD ./Application/config/boto.cfg /etc/boto.cfg
ADD ./Application/server.config ./Application/prod.config 

# Install dependencies
WORKDIR ./Application/
RUN bash setup.sh
RUN bash setup-ec2.sh
RUN chmod +x local.sh
WORKDIR /

EXPOSE 80
EXPOSE 443
#EXPOSE 5533
RUN sudo /etc/init.d/nginx restart

# TODO: Path unlikely to be correct...
CMD ["bash", "/Application/local.sh"]
