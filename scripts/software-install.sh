#!/bin/bash

sudo apt-get update

sudo apt-get upgrade -y

sudo apt-get install -y \
  software-properties-common apt-transport-https ca-certificates \
  curl zip unzip tree htop \
  git git-flow \
  emacs \
  php7.2 php7.2-bcmath php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-opcache php7.2-pgsql php7.2-xml php7.2-zip php-redis php-xdebug \
  zsh \
  gimp \
  openvpn \
  gnome-shell-extensions chrome-gnome-shell \
  ttf-ancient-fonts

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
    sudo mv composer.phar /usr/bin/composer
  fi
fi

# node / npm install
if [[ ! -x "$(which node)" ]]; then
  curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
  sudo apt install -y nodejs
fi

# Install java
if [[ ! -x "$(which java)" ]]; then
  sudo add-apt-repository ppa:openjdk-r/ppa
  sudo apt-get update
  sudo apt-get install -y openjdk-11-jdk maven
fi

# Docker Install (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)
if [[ ! -x "$(which docker)" ]]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  sudo apt update
  sudo apt install -y docker-ce
  sudo systemctl disable docker
  sudo adduser ${USER} docker
fi

# Docker compose install (https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04)
if [[ ! -f /usr/local/bin/docker-compose ]]; then
  sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# Antigen install
if [[ ! -f ~/.antigen/antigen.zsh ]]; then
  mkdir -p ~/.antigen
  curl -L git.io/antigen > ~/.antigen/antigen.zsh
fi

# Installation enpass
if [[ ! -f /opt/enpass/Enpass ]]; then
  sudo sh -c 'echo "deb https://apt.enpass.io/ stable main" > /etc/apt/sources.list.d/enpass.list'
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install -y enpass
fi

# Installation spotify
if [[ ! -x "$(which spotify)" ]]; then
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
  echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
  sudo apt-get update
  sudo apt-get install -y spotify-client
fi

# Installation rocket chat
if [[ ! -x "$(which rocketchat-desktop)" ]]; then
 wget https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/2.14.7/rocketchat_2.14.7_amd64.deb
 sudo dpkg -i rocketchat_2.14.7_amd64.deb
 rm rocketchat_2.14.7_amd64.deb
 sudo apt --fix-broken install -y
fi

# Install SoyHuCe certificates
curl -sL http://keys.soyhuce.lan/install-ca.sh | sudo bash -
