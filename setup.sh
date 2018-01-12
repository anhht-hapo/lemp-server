#!/bin/bash

function set_mysql {
    echo "DB_DATABASE :";
    read DB_DATABASE;
    echo "DB_USERNAME :";
    read DB_USERNAME;
    echo "DB_PASSWORD :";
    read DB_PASSWORD;
}
set_mysql

echo "Link git repository :";
read GIT_LINK;
echo "Project name: "
read PRO_NAME;
# Update
# apt-get update
# Install cURL & ZIP/UNZIP & git
 apt-get install -y curl
 apt-get install -y zip unzip
 apt-get install -y git
echo "Git Installed Successfully!"
git config --global user.name "Your Name"
git config --global user.email "youremail@domain.com"
# Install Nginx
chmod 777 Nginx.sh
./Nginx.sh

# Install MySQL
if [ -f `which mysql` ] ; then

 apt-get -y install mysql-server mysql-client
fi

DBEXISTS=$(mysql --batch --skip-column-names -e "SHOW DATABASES LIKE '"$DB_DATABASE"';" | grep "$DB_DATABASE" > /dev/null; echo "$?")

while : ; do
    if [ $DBEXISTS -eq 0 ];then
        echo "A database with the name $DB_DATABASE already exists. Please re-enter."
        set_mysql;
    else
        break;
    fi
done

service mysql start;
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${DB_DATABASE} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${DB_USERNAME}@localhost IDENTIFIED BY '${DB_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USERNAME}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else

    mysql -uroot -e "CREATE DATABASE ${DB_DATABASE} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -e "CREATE USER ${DB_USERNAME}@localhost IDENTIFIED BY '${DB_PASSWORD}';"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USERNAME}'@'localhost';"
    mysql -uroot -e "FLUSH PRIVILEGES;"
fi
# Install PHP
chmod 777 php-install.sh
./php-install.sh
# # Git Clone your Site
export COMPOSER_ALLOW_SUPERUSER=1

git clone $GIT_LINK /var/www/$PRO_NAME

cd /var/www/$PRO_NAME
echo "APP_ENV=local
APP_DEBUG=true
APP_KEY=base64:Y6CZKraJe9eBR1OxuiVBCHHNHNl9fh1r8UwCw+64OyM=
APP_URL=http://localhost/

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE= $DB_DATABASE
DB_USERNAME= $DB_USERNAME
DB_PASSWORD= $DB_PASSWORD 
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=log
MAIL_HOST=mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null"> .env
composer install
composer update
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan serve