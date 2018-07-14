#!/usr/bin/env bash

CONF_PATH=/home/vagrant/vm/conf
PHP_PATH=/usr/local/php7

if [ ! -e "/usr/local/php7/bin/php" ]; then
    echo ">>> Compiling php7"

    sudo yum install -y wget git gcc gcc-c++ libxml2-devel pkgconfig openssl-devel bzip2-devel curl-devel libpng-devel libjpeg-devel libXpm-devel freetype-devel gmp-devel libmcrypt-devel mariadb-devel aspell-devel recode-devel autoconf bison re2c libicu-devel bzip2

    sudo mkdir -p /usr/local/php7
    sudo mkdir -p /usr/local/php7/etc/conf.d
    sudo mkdir -p /usr/local/php7/etc/php-fpm.d

    cd /home/vagrant
    wget http://cn2.php.net/get/php-7.1.18.tar.bz2/from/this/mirror -O php-7.1.18.tar.bz2 > /dev/null
    tar -xvf php-7.1.18.tar.bz2

    cd /home/vagrant/php-7.1.18
    ./buildconf --force
    ./configure --prefix=/usr/local/php7 \
    --with-config-file-path=/usr/local/php7/etc \
    --with-config-file-scan-dir=/usr/local/php7/etc/conf.d \
    --enable-bcmath \
    --with-bz2 \
    --with-curl \
    --enable-filter \
    --enable-fpm \
    --with-gd \
    --enable-gd-native-ttf \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --enable-intl \
    --enable-mbstring \
    --with-mcrypt \
    --enable-mysqlnd \
    --with-mysql-sock=/var/lib/mysql/mysql.sock \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite \
    --disable-phpdbg \
    --disable-phpdbg-webhelper \
    --enable-opcache \
    --with-openssl \
    --enable-simplexml \
    --with-sqlite3 \
    --enable-xmlreader \
    --enable-xmlwriter \
    --with-zlip \
    --enable-zip 
    make -j2
    sudo make && sudo make install

    sudo ln -fs /usr/local/php7/bin/php /usr/local/bin/php
    sudo ln -fs /usr/local/php7/sbin/php-fpm /usr/sbin/php-fpm

    sudo cp ${CONF_PATH}/php.ini-development ${PHP_PATH}/lib/php.ini
    sudo cp ${CONF_PATH}/php-fpm.conf ${PHP_PATH}/etc/php-fpm.conf
    sudo cp ${CONF_PATH}/php-fpm-pool.conf ${PHP_PATH}/etc/php-fpm.d/www.conf
    sudo cp ${CONF_PATH}/php-fpm.service /usr/lib/systemd/system/php-fpm.service

    sudo chkconfig --levels 235 php-fpm on
    sudo systemctl start php-fpm

    echo ">>> PHP7 installed"
else
    echo ">>> PHP7 Already installed"
fi


