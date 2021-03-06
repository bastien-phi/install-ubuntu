#!/bin/bash

# Configure zsh / antigen
cp resources/zsh/.zshrc ~/.zshrc
cp resources/zsh/.zsh_aliases ~/.zsh_aliases
/bin/zsh ~/.zshrc
cp resources/zsh/philippe.zsh-theme ~/.antigen/bundles/robbyrussell/oh-my-zsh/themes
/bin/zsh -c 'source ~/.zshrc && antigen reset'
chsh -s /bin/zsh

# Configure git
cp resources/git/.gitconfig ~/.gitconfig
cp resources/git/.gitignore ~/.gitignore

# Deactivate xdebug
sudo cp resources/php/xdebug.ini /etc/php/7.2/mods-available/xdebug.ini

# configure ssh
cp resources/ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config

# Increase inotify limit for Jetbrains IDEs
sudo sh -c "echo 'fs.inotify.max_user_watches = 524288' > /etc/sysctl.d/20-inotify.conf"
sudo sysctl -p --system
