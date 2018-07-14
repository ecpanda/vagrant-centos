#!/usr/bin/env bash
if [ ! -e "/usr/local/bin/php" ]; then
    echo ">>> Installing php7.1.18"

    sudo cp -r /home/vagrant/vm/dist/php7 /usr/local

    sudo ln -fs /usr/local/php7/bin/php /usr/local/bin/php
    sudo ln -fs /usr/local/php7/sbin/php-fpm /usr/sbin/php-fpm

    sudo cp /home/vagrant/vm/conf/php-fpm.service /usr/lib/systemd/system/php-fpm.service

    sudo chkconfig --levels 235 php-fpm on
    sudo systemctl start php-fpm

    echo ">>> PHP7.1.18 installed under /usr/local/php7"
else
    echo ">>> PHP7.1.18 Already installed"
fi


