#!/bin/bash

# Link dotfiles
cd resources/dotfiles/
for file in `ls .*`; do
  rm -f "$HOME/$file"
  ln -s "$(pwd)/$file" "$HOME/$file"
done
cd -

# Configure zsh / antigen
/bin/zsh ~/.zshrc
cp resources/zsh/philippe.zsh-theme ~/.antigen/bundles/robbyrussell/oh-my-zsh/themes
/bin/zsh -c 'source ~/.zshrc && antigen reset'
chsh -s /bin/zsh

# Increase inotify limit for Jetbrains IDEs
sudo sh -c "echo 'fs.inotify.max_user_watches = 524288' > /etc/sysctl.d/20-inotify.conf"
sudo sysctl -p --system

