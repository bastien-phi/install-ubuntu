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
  net-tools \
  gnome-shell-extensions gnome-shell-extension-manager

# Install php
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y \
 php8.\
 php8.4-bcmath \
 php8.4-curl \
 php8.4-gd \
 php8.4-igbinary \
 php8.4-intl \
 php8.4-mbstring \
 php8.4-pcov \
 php8.4-pgsql \
 php8.4-redis \
 php8.4-sqlite3 \
 php8.4-xml \
 php8.4-zip


# composer install
if [[ ! -f /usr/bin/composer ]]; then
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  php composer-setup.php --quiet
  rm composer-setup.php
fi

# Install node, npm and pnpm (https://deb.nodesource.com/)
if [[ ! -x "$(which node)" ]]; then
  curl -sL https://deb.nodesource.com/setup_22.x | sudo bash -
  sudo apt install -y nodejs
  sudo npm -g add pnpm
fi

# Docker Install (https://docs.docker.com/engine/install/ubuntu/)
if [[ ! -x "$(which docker)" ]]; then
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Zsh - Oh my zsh - Antigen install
if [[ ! -x "$(which zsh)" ]]; then
  sudo apt install -y zsh
  mkdir -p ~/.antigen
  curl -L git.io/antigen > ~/.antigen/antigen.zsh
fi

# Installation enpass (https://www.enpass.io/support/kb/general/how-to-install-enpass-on-linux/)
if [[ ! -f /opt/enpass/Enpass ]]; then
  echo "deb https://apt.enpass.io/  stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo tee /etc/apt/trusted.gpg.d/enpass.asc
  sudo apt update
  sudo apt install enpass
fi

# Installation spotify
if [[ ! -x "$(which spotify)" ]]; then
  sudo snap install spotify
fi

# Bin directory
if [[ ! -d ~/bin ]]; then
  mkdir ~/bin
fi

if [[ ! -f ~/bin/README.md ]]; then
  cp resources/docs/bin_readme.md ~/bin/README.md
fi

# Installation brave browser (https://brave.com/linux/)
if [[ ! -x "$(which brave-browser)" ]]; then
  curl -fsS https://dl.brave.com/install.sh | sh
fi
