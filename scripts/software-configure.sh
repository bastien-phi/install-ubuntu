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
sudo sh -c "echo 'fs.inotify.max_user_watches = 524288' >> /etc/sysctl.conf"
# Decrease Swappiness to prefer using RAM over swap
sudo sh -c "echo 'vm.swappiness = 5' >> /etc/sysctl.conf"

sudo sysctl -p --system

# Install Jetbrains mono font
mkdir -p ~/.local/share/fonts
cp resources/fonts/JetBrainsMono-2.304.zip ~/.local/share/fonts
unzip ~/.local/share/fonts/JetBrainsMono-2.304.zip
fc-cache -f -v
