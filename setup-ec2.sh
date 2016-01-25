# Configure nginx
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /Application/config/recommender.x-in-y.conf /etc/nginx/conf.d/
sudo apt-get -y update && sudo apt-get -y upgrade

# Copy SSL Certificates
sudo aws s3 cp s3://s3-oregon-zone-specialkeys-for-et/unified-wildcard.x-in-y.crt /etc/ssl/unified-wildcard.x-in-y.crt
sudo aws s3 cp s3://s3-oregon-zone-specialkeys-for-et/wildcard.x-in-y.key /etc/ssl/wildcard.x-in-y.key

sudo apt-get update