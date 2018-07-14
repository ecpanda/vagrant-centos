#!/usr/bin/env bash

if [ ! -e "/usr/bin/mysql" ]; then
    echo ">>> Installing Mysql"

    sudo yum install -y mariadb-server mariadb
    sudo systemctl start mariadb
    sudo systemctl enable mariadb

    # create user - username: admin; password: admin
    echo ">>>> Assigning mysql user access on %. username:admin; password:admin"
    sudo mysql -uroot --execute "CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';"
    sudo mysql -uroot --execute "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'admin' with GRANT OPTION; FLUSH PRIVILEGES;"

    echo ">>>> Assigned mysql user root access on all hosts."
else
    echo ">>> Mysql already installed"
fi



