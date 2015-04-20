#!/bin/bash

####################################################################################
# @package phalcon2 installer
# @author Zeki Unal <zekiunal@gmail.com>
# @name phalcon2.sh
####################################################################################

####################################################################################
# Install wget
####################################################################################

if ! rpm -qa | grep -qw wget; then
    # install wget
    sudo yum install -y wget 
    echo "wget installed."
fi

####################################################################################
# Update CentOS
####################################################################################
sudo yum update -y


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

if ! rpm -qa | grep -qw php56; then
    yum install -y php56
    echo "php56 installed."
fi

if ! rpm -qa | grep -qw php56-opcache; then
    yum install -y php56-opcache
    echo "php56-opcache installed."
fi

if ! rpm -qa | grep -qw php56-common; then
    yum install -y php56-common
    echo "php56-common installed."
fi

if ! rpm -qa | grep -qw php56-mysql; then
    yum install -y php56-mysql
    echo "php56-mysql installed."
fi

if ! rpm -qa | grep -qw php56-pecl-memcache; then
    yum install -y php56-pecl-memcache
    echo "php56-pecl-memcache installed."
fi

if ! rpm -qa | grep -qw php56-devel; then
    sudo yum install -y php56-devel
    echo "php56-devel installed."
fi

if ! rpm -qa | grep -qw gcc; then
    sudo yum install -y gcc
    echo "gcc installed."
fi

if ! rpm -qa | grep -qw libtool; then
    sudo yum install -y libtool
    echo "libtool installed."
fi

if ! rpm -qa | grep -qw make; then
    sudo yum install -y make
    echo "make installed."
fi

if ! rpm -qa | grep -qw git-core; then
    sudo yum install -y git-core
    echo "git installed."
fi

if ! rpm -qa | grep -qw gd; then
    sudo yum install -y gd
    echo "gd installed."
fi

if ! rpm -qa | grep -qw gd-devel; then
    sudo yum install -y gd-devel
    echo "gd-devel installed."
fi

if ! rpm -qa | grep -qw php56-gd; then
    sudo yum install -y php56-gd
    echo "php56-gd installed."
fi

if [ ! -f /usr/lib64/php/modules/phalcon.so ]; then

    git clone --depth=1 git://github.com/phalcon/cphalcon.git
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
