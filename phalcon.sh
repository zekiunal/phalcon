#!/bin/bash

##########################################
# @package server initialize
# @author Zeki Ünal <zekiunal@gmail.com>
# @name phalcon.sh
##########################################

yum update -y
rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
yum install -y httpd
chkconfig httpd on

grep -l '#ServerName www.example.com:80' /etc/httpd/conf/httpd.conf | xargs sed -e 's/#ServerName www.example.com:80/ServerName localhost/' -i
grep -l '#NameVirtualHost \*:80' /etc/httpd/conf/httpd.conf | xargs sed -e 's/#NameVirtualHost \*:80/NameVirtualHost \*:80/g' -i
grep -l 'AllowOverride None' /etc/httpd/conf/httpd.conf | xargs sed -e 's/AllowOverride None/AllowOverride All/g' -i


#remove empty lines
sed -i '/^$/d' /etc/httpd/conf/httpd.conf
service httpd start

cd /
mkdir /etc/httpd/conf/virtualhosts

echo "Apache installed."

if ! rpm -qa | grep -qw php55w; then
    yum install -y php55w
    echo "php55w installed."
fi

if ! rpm -qa | grep -qw php55w-opcache; then
    yum install -y php55w-opcache
    echo "php55w-opcache installed."
fi

if ! rpm -qa | grep -qw php55w-common; then
    yum install -y php55w-common
    echo "php55w-common installed."
fi

if ! rpm -qa | grep -qw php55w-mysql; then
    yum install -y php55w-mysql
    echo "php55w-mysql installed."
fi

if ! rpm -qa | grep -qw php55w-pecl-memcache; then
    yum install -y php55w-pecl-memcache
    echo "php55w-pecl-memcache installed."
fi

if ! rpm -qa | grep -qw php55w-devel; then
    sudo yum install -y php55w-devel
    echo "php55w-devel installed."
fi

if ! rpm -qa | grep -qw gcc; then
    sudo yum install -y gcc
    echo "gcc installed."
fi

if ! rpm -qa | grep -qw make; then
    sudo yum install -y make
    echo "make installed."
fi

if ! rpm -qa | grep -qw git-core; then
    sudo yum install -y git-core
    echo "git installed."
fi

if [ ! -f /usr/lib64/php/modules/phalcon.so ]; then
    git clone git://github.com/phalcon/cphalcon.git
    cd cphalcon/build
    sudo ./install
    if [ ! -L /etc/php.d/phalcon.ini ]
    then
                rm -f -r /etc/php.d/phalcon.ini
                echo "; Enable phalcon extension module" >> /etc/php.d/phalcon.ini
        echo "extension=phalcon.so" >> /etc/php.d/phalcon.ini
                echo 'date.timezone = "Europe/Istanbul"' >> /etc/php.d/phalcon.ini
    fi
    cd /
    clear
fi


service httpd restart

echo "########### Apache Installed ###########"
