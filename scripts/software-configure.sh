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

# Configure apache modules
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo systemctl restart apache2

id mailpit >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
  # Create mailpit user
  sudo groupadd -r mailpit
  sudo useradd -M -r -g mailpit mailpit
  # Add some storage
  sudo mkdir -p /var/lib/mailpit
  sudo chown mailpit:mailpit /var/lib/mailpit
  # Enable service
  sudo cp resources/services/mailpit.service /usr/lib/systemd/system/mailpit.service
  sudo systemctl enable mailpit.service
  sudo systemctl start mailpit.service
  # Configure Apache
  sudo cp resources/apache2/mailpit.conf /etc/apache2/sites-available/mailpit.conf
  sudo a2ensite mailpit
  sudo systemctl reload apache2
fi

id minio-user >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
  # Create minio user
  sudo groupadd -r minio-user
  sudo useradd -M -r -g minio-user minio-user
  # Add some storage
  sudo mkdir -p /var/lib/minio
  sudo chown minio-user:minio-user /var/lib/minio
  # Enable service
  sudo cp resources/services/minio.service /usr/lib/systemd/system/minio.service
  sudo cp resources/services/minio.env /etc/default/minio
  sudo systemctl enable minio.service
  sudo systemctl start minio.service
  # Configure Apache
  sudo cp resources/apache2/minio.conf /etc/apache2/sites-available/minio.conf
  sudo a2ensite minio
  sudo systemctl reload apache2
fi
