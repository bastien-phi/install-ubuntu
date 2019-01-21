#!/bin/bash

# Configure zsh / antigen
cp ../resources/zsh/.zshrc ~/.zshrc
cp ../resources/zsh/.zsh_aliases ~/.zsh_aliases
source ~/.zshrc
cp ../resources/zsh/philippe.zsh-theme ~/.antigen/bundles/robbyrussell/oh-my-zsh/themes
antigen reset
chsh -s /bin/zsh
