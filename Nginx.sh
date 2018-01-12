#!/bin/sh

# install nginx
 apt-get install -y nginx

# update the config
 wget https://gist.githubusercontent.com/sandcastle/9282638/raw/nginx.conf -O /etc/nginx/sites-available/teamcity
 mkdir -p /var/www/teamcity

# create syn link
 ln -s /etc/nginx/sites-available/teamcity /etc/nginx/sites-enabled/teamcity

# reload
 /etc/init.d/nginx reload
echo "Your Home Directory is /var/www/html/. You can start using that Home Directory."
