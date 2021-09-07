#!/bin/bash

sudo apt update

sudo apt upgrade -y

# Install tools
sudo apt install -y \
  software-properties-common apt-transport-https ca-certificates gnupg lsb-release \
  curl zip unzip tree htop xclip \
  git git-flow \
  emacs \
  gimp \
  openvpn \
  gnome-shell-extensions chrome-gnome-shell

# Install php
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y \
 php8.0 \
 php8.0-bcmath \
 php8.0-curl \
 php8.0-gd \
 php8.0-intl \
 php8.0-mbstring \
 php8.0-opcache \
 php8.0-pgsql \
 php8.0-redis \
 php8.0-soap \
 php8.0-sqlite3 \
 php8.0-xml \
 php8.0-xdebug \
 php8.0-zip

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
    rm composer-setup.php
    sudo mv composer.phar /usr/bin/composer
  fi
fi

# Install node, npm and yarn
if [[ ! -x "$(which node)" ]]; then
  curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
  sudo apt install -y nodejs yarn
fi

# Install java
if [[ ! -x "$(which java)" ]]; then
  sudo apt install -y openjdk-11-jdk maven
fi

# Docker Install (https://docs.docker.com/engine/install/ubuntu/)
if [[ ! -x "$(which docker)" ]]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-cs-cle contenerd.io
  sudo systemctl disable docker
  sudo adduser ${USER} docker
fi

# Docker compose install (https://docs.docker.com/compose/install/)
if [[ ! -f /usr/local/bin/docker-compose ]]; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# Zsh - Oh my zsh - Antigen install
if [[ ! -x "$(which zsh)" ]]; then
  sudo apt install -y zsh
  mkdir -p ~/.antigen
  curl -L git.io/antigen > ~/.antigen/antigen.zsh
fi

# Installation enpass
if [[ ! -f /opt/enpass/Enpass ]]; then
  sudo sh -c 'echo "deb https://apt.enpass.io/ stable main" > /etc/apt/sources.list.d/enpass.list'
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | tee /etc/apt/trusted.gpg.d/enpass.asc
  sudo apt update
  sudo apt install -y enpass
fi

# Installation spotify
if [[ ! -x "$(which spotify)" ]]; then
  sudo snap install spotify-client
fi

# Installation rocket chat
if [[ ! -x "$(which rocketchat-desktop)" ]]; then
  sudo snap install rocketchat-desktop
fi

# Install SoyHuCe certificates
curl -o /usr/local/share/ca-certificates/soyhuce.crt -sSL http://keys.soyhuce.lan/ca.pem \
  && curl -o /usr/local/share/ca-certificates/ca_easyrsa.crt -sSL http://keys.soyhuce.lan/ca_easyrsa.crt \
  && update-ca-certificates

# Stoplight studio
if [[ ! -d ~/bin ]]; then
  mkdir ~/bin
  cp resources/docs/bin_readme.md ~/bin/README.md
fi

if [[ ! -f ~/bin/stoplight-studio-linux-x86_64.AppImage ]]; then
  curl -o ~/bin/stoplight-studio-linux-x86_64.AppImage -sSL https://github.com/stoplightio/studio/releases/latest/download/stoplight-studio-linux-x86_64.AppImage
  chmod +x ~/bin/stoplight-studio-linux-x86_64.AppImage
fi

# Installation drawio
if [[ ! -x "$(which drawio)" ]]; then
  sudo snap install drawio
fi

# Installation brave browser
if [[ ! -x "$(which brave-browser)" ]]; then
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
    sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install brave-browser
fi

# Installation glab (https://github.com/profclems/glab#installation)
if [[ ! -x "$(which glab)" ]]; then
  curl -s https://raw.githubusercontent.com/profclems/glab/trunk/scripts/install.sh | sudo sh
fi

# Installation weasyprint
if [[ ! -x "$(which weasyprint)" ]]; then
  sudo apt install -yqq build-essential \
      python3-dev python3-pip python3-setuptools python3-wheel python3-cffi \
      libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info
  sudo pip3 install weasyprint
fi
