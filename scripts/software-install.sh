#!/bin/bash

sudo apt-get update

sudo apt-get install -y \
  software-properties-common apt-transport-https ca-certificates \
  curl zip unzip \
  git git-flow \
  emacs \
  php7.2 php7.2-bcmath php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-opcache php7.2-pgsql php7.2-xml php7.2-zip php-redis php-xdebug \


# composer install
if [[ ! -f /usr/bin/composer ]]; then
  EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [[ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]]; then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
  else
    php composer-setup.php
    RESULT=$?
    rm composer-setup.php
    mv composer.phar /usr/bin/composer
  fi
fi

# node / npm install
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt install -y nodejs

# Docker Install (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce
sudo systemctl disable docker
sudo adduser ${USER} docker

# Docker compose install (https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04)
if [[ ! -f /usr/local/bin/docker-compose ]]; then
  sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

