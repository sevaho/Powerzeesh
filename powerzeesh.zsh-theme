FG=black
SYMBOLS=()
CURRENT_BG=7
fg=white

# colors picked from 256 colors
color_prompt_name_bg=10
color_prompt_name_fg=10
color_prompt_root_bg=1
color_prompt_root_fg=1

color_prompt_dir_bg=8
color_prompt_dir_fg=14
color_prompt_dir_root_bg=8
color_prompt_dir_root_fg=11

color_prompt_white=15
color_prompt_git_green=2
color_prompt_git_orange=208
color_prompt_git_red=1

# segments
prompt_segment () {

    local bg

    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"

    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then

        print -n "%{$fg%}"

    else

        print -n "%{$fg%}"

    fi

    CURRENT_BG=$1
    [[ -n $3 ]] && print -n $3

}

prompt_context () {

    local user=`whoami`

    if [[ -n "$SSH_CONNECTION" ]]; then

        prompt_segment $color_prompt_name_bg $color_prompt_name_fg "%{%F{white}%}[SSH] %{%F{yellow}%}%{%F{$color_prompt_name_fg}%}${HOST}"

    elif [[ $(id -u) -ne 0 ]]; then

        prompt_segment $color_prompt_name_bg $color_prompt_name_fg "$"

    else

        prompt_segment $color_prompt_root_bg $color_prompt_root_fg "#"

    fi

}

prompt_git () {

    local color ref

    is_dirty () {

        test -n "$(git status --porcelain --ignore-submodules)"

    }

    commitsAhead () {

        test -n "$(git_commits_ahead)"

    }

    ref="$vcs_info_msg_0_"

    if [[ -n "$ref" ]]; then

        if is_dirty; then

            color=$color_prompt_git_red
            ref="${ref} $PLUSMINUS"

        elif commitsAhead; then

            color=$color_prompt_git_orange
            ref="${ref} $STAR"

        else

            color=$color_prompt_git_green
            ref="${ref} "

        fi

        if [[ "${ref/.../}" == "$ref" ]]; then

            ref="$BRANCH $ref"

        else

            ref="$DETACHED ${ref/.../}"

        fi

        prompt_segment $color

    fi

}

prompt_fossil () {

    local _OUTPUT=`fossil branch 2>&1`
    local _STATUS=`echo $_OUTPUT | grep "use --repo"`

    if [ "$_STATUS" = "" ]; then

        local _EDITED=`fossil changes`
        local _EDITED_SYM="$ZSH_THEME_FOSSIL_PROMPT_CLEAN"

        if [ "$_EDITED" != "" ]; then

            color=$color_prompt_git_red

        else

            color=$color_prompt_git_green

        fi

        prompt_segment $color $FG

    fi

}

prompt_dir () {

    prompt_segment $color_prompt_dir_bg $color_prompt_dir_fg ' %~'

}

# status:
# - error
# - jobs
# - vagrant
# - nodejs
prompt_status () {

    [[ $RETVAL -ne 0 ]] && SYMBOLS+="%{%F{red}%}$RETVAL "
    [[ $(jobs -l | wc -l) -gt 0 ]] && SYMBOLS+="%{%F{cyan}%}J "

    # vagrant
    if [[ -d ./.vagrant/machines  ]]; then

        if [[ -f .vagrant/machines/default/virtualbox/id && $(VBoxManage list runningvms | grep -c $(/bin/cat .vagrant/machines/*/*/id)) -gt 0  ]]; then

            SYMBOLS+="%{%F{green}%}V "
            else
            SYMBOLS+="%{%F{red}%}V "

        fi

    fi

    if [[ -d ./node_modules ]]; then

        SYMBOLS+="%{%F{green}%}`node -v 2> /dev/null` "

    fi

    prompt_segment $FG default "$SYMBOLS"

}

prompt_virtualenv () {

    if [[ -n $VIRTUAL_ENV ]]; then

        color=cyan
        prompt_segment $color $FG
        print -Pn " $(basename $VIRTUAL_ENV) "

    fi

}

prompt_end () {

    [[ $CURRENT_BG == 8 ]] && print -n "%{%k%F{white}%} ❯" || print -n "%{%k%F{$CURRENT_BG}%} ❯"

}

# prompt right
prompt_right () {


}

prompt () {

    RETVAL=$?
    CURRENT_BG=red
    prompt_status
    prompt_context
    prompt_virtualenv
    prompt_dir
    prompt_git
    prompt_fossil
    prompt_end

}

prompt_precmd () {

    vcs_info
    PROMPT='%{%f%b%k%}$(prompt) '
    RPROMPT='%{%f%b%k%}$(prompt_right) '

}

prompt_setup () {

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    prompt_opts=(cr subst percent)

    add-zsh-hook precmd prompt_precmd

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' check-for-changes false
    zstyle ':vcs_info:git*' formats '%b'
    zstyle ':vcs_info:git*' actionformats '%b (%a)'

}

prompt_setup "$@"

