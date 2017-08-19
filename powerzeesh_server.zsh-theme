
local user=`whoami`

if [[ $(id -u) -ne 0 || -n "$SSH_CONNECTION" ]]; then

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%n%{$fg[cyan]%}@%{$fg_bold[green]%}%m%{$fg_bold[green]%}%p%{$fg[cyan]%}%~%{$fg_bold[blue]%}$(git_prompt_info) %{$fg_bold[blue]%}% %{$reset_color%}'

else

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[red]%}%n%{$fg[cyan]%}@%{$fg_bold[red]%}%m%{$fg_bold[green]%}%p%{$fg[cyan]%}%~%{$fg_bold[blue]%}$(git_prompt_info) %{$fg_bold[blue]%}% %{$reset_color%}'

fi

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

