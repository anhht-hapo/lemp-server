#!/bin/bash
# Install PHP
 apt-get install -y php libapache2-mod-php php-mcrypt php-mysql
# Y to allow to use disk space

# Install PHP Required Extensions
 apt-get install -y php-cli php-mbstring php-gettext php-curl php-zip
 phpenmod mcrypt
 phpenmod mbstring
 phpenmod curl
echo "php-cli, curl, mcrypt, mbstring Installed Successfully!"

 a2enmod rewrite
 a2enmod ssl

# Install PHP Dev
 apt install -y php7.0-dev
echo "php7.0-dev Installed Successfully!"

 apt-get install -y php7.0-intl
echo "php7.0-intl Installed Successfully!"

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
echo "Composer Installed Successfully!"
