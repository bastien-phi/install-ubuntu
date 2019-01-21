if [[ $UID -eq 0 ]]; then
    user_host="%{$fg_bold[red]%}%n@%m%{$reset_color%}"
    the_user_symbol='#'
else
    user_host="%{$fg_bold[green]%}%n@%m%{$reset_color%}"
    the_user_symbol='$'
fi

# returns 0 if git directory
function is_git() {
  echo $(command git rev-parse --is-inside-work-tree 2> /dev/null)
}

function user_symbol() {
  if [[ -n $(is_git) ]]; then
      echo
  fi
  echo "%B${the_user_symbol}%b"
}

local current_dir="%{$fg_bold[blue]%}%~%{$reset_color%}"

function git_status_info() {
  if [[ -n $(is_git) ]]; then
    if [[ -n "$(command git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]; then
      # remote exists
      echo $(git_prompt_info)$(git_prompt_status)$(git_remote_status)$(git_commits_ahead)$(git_commits_behind)
    else
      echo $(git_prompt_info)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_REMOTE_MISSING
    fi
  fi
}

PROMPT='$user_host:$current_dir$(git_status_info) $(user_symbol) '


ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%}) "
ZSH_THEME_GIT_PROMPT_DIRTY=$ZSH_THEME_GIT_PROMPT_CLEAN

ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE="%{$fg_bold[green]%}✔%{$reset_color%}"

ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX="%{$fg_bold[cyan]%}⇧ "
ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX="%{$fg_bold[red]%}⇩ "
ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX="%{$reset_color%}"

DISABLE_UNTRACKED_FILES_DIRTY=true

ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}✗ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}⁉ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}🞢 %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}− %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[yellow]%}∓ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[yellow]%}★ %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_REMOTE_MISSING="%{$fg_bold[cyan]%}🖳 %{$reset_color%}"
