bindkey "^[[1;2C" forward-word
bindkey "^[[1;2D" backward-word

source ~/.antigen/antigen.zsh

antigen use oh-my-zsh # Load the oh-my-zsh's library

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle web-search
antigen bundle npm
antigen bundle colored-man-pages
antigen bundle encode64
antigen bundle git
antigen bundle git-flow
antigen bundle ssh
antigen bundle yarn

antigen bundle zsh-users/zsh-autosuggestions      # Fish-like auto suggestions
antigen bundle zsh-users/zsh-completions          # Extra zsh completions

antigen theme philippe # Load the theme
antigen apply  # Tell antigen that you're done

source $HOME/.zsh_aliases
export EDITOR=emacs
export PATH=~/.local/bin:~/.config/composer/vendor/bin:/home/philippe/.yarn/bin:~/bin:~/.local/share/JetBrains/Toolbox/scripts:~/.symfony5/bin:$PATH
export PAGER="less -F"
export PHP_CS_FIXER_IGNORE_ENV=1

# pnpm
export PNPM_HOME="/usr/lib/node_modules/pnpm/bin"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
