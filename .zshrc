# Created by newuser for 5.1.1
export HISTSIZE=60000         # Increases size of history
export SAVEHIST=60000
export VISUAL=vim
export EDITOR="$VISUAL"
export SHELL='/bin/zsh'

#alias

# User configuration
typeset -U path cdpath fpath manpath
path=(/usr/local/bin ${HOME}/local/bin/ /usr/pgsql-9.2/bin ${HOME}/bin ./git-cleanup  $path)


typeset -ga pythonpath
#pythonpath=(
#
#)

setopt prompt_subst
setopt transient_rprompt
# VCS prompt information
autoload -Uz vcs_info
# Prompt
# Color code conversion table.
# norm  %{\e[0;3  0  1  2  3  4  5  6  7  m%}
# norm  %F{       0  1  2  3  4  5  6  7  }
# bold  %{\e[1;3  0  1  2  3  4  5  6  7  m%}
# bold  %F{       8  9 10 11 12 13 14 15  }
# reset %{\e[0m%} -> %f

# Use different colors for local root.
local ps1_col=$'%(?.%(#.%F{3}.%F{2}).%F{1})'
local ps2_col=$'%(?.%(#.%F{11}.%F{10}).%F{9})'

# NOTE: Changing to root ignores $SSH_ variables
if [[ -n "$SSH_CONNECTION" ]]; then
  local ps1_col=$'%(?.%(#.%F{3}.%F{4}).%F{1})'
  local ps2_col=$'%(?.%(#.%F{11}.%F{12}).%F{9})'
fi

# Visualize keymap for vi bindings depending on mode.
update-prompt() {
  # Fix empty $KEYMAP bug by setting initial in update-prompt.  When switching
  # to vicmd on start, add empty string to vicmd case to yield: vicmd|'')
  case $KEYMAP in
    vicmd)
      PS1=$'${ps1_col}>>> %f'
      PS2=$'${ps2_col}>>= %f'
      ;;
    *)
      PS1=$'%F{8}>${ps1_col}>${ps2_col}> %f'
      PS2=$'%F{8}>>${ps1_col}= %f'
      ;;
  esac
}

# precmd()
# Update prompt and vcs info, set terminal title.
case $TERM in
  xterm*|st*|rxvt*|(dt|k|E)term|screen*)
    precmd () {
      update-prompt
      # vcs_info  # Crashes for zsh 4.3.10
      print -Pn $'\e]2;%n@%m:%~\a'
    }
    ;;
esac


# User specific aliases and functions
export PATH="/usr/pgsql-9.3/bin:/usr/pgsql-9.2/bin:$PATH"
#export PYTHONPATH=

export PYTHONPATH=${(j':')pythonpath}

#aliases
#alias sprlnbses="ssh prod-lnb-search-01 -L 9200:localhost:9200 -N"

# Load virtualenv
#if [[ -f "/data/virtualenv/default/bin/activate" ]]; then
#  source "/data/virtualenv/default/bin/activate"
#fi

tshare() {  # {{{3
# Share tmux session
  # If no tmux session present, stop.
  if [[ -z "$TMUX" ]]; then
    echo "$0 -> no tmux server running!" >&2
    return 1
  fi

  # Get socket and session name
  local SOCKET=$(echo $TMUX | cut -d, -f1)
  local SESSION=$(/usr/bin/tmux display-message -p "#S")

  # Enable access
  chgrp deploy $SOCKET
  chmod g+rwx $SOCKET

  echo -e "
  Access to your tmux session has been enabled for the deploy group.
  Group members can now join with the following command:
    ssh $HOSTNAME -t 'tmux -S $SOCKET attach -t $SESSION -r'
  "
}

ctmux(){
if [[ "$TERM" != "screen-256color" && -n "$SSH_TTY" ]]; then
  # Create symlink to new socket before attaching to tmux.
  # Needs `set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/.ssh_auth_sock`
  if [[ -n "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" == /tmp/* ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/.ssh_auth_sock
  fi

  # Create new or attach to existing tmux session.
  tmux -S /tmp/tmux-$USER attach-session -t "unata" \
    || tmux -S /tmp/tmux-$USER new-session -s "unata"
    # \; source-file "${HOME}/.tmux/unata"
fi
}

# misc
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down]]]]"


# Support colors in less.
export LESS_TERMCAP_mb=$'\e[00;31m'   # begin blinking
export LESS_TERMCAP_md=$'\e[00;31m'   # begin bold
export LESS_TERMCAP_so=$'\e[44;30m'   # begin standout-mode
export LESS_TERMCAP_se=$'\e[0m'       # end standout-mode
export LESS_TERMCAP_us=$'\e[00;32m'   # begin underline
export LESS_TERMCAP_ue=$'\e[0m'       # end underline
export LESS_TERMCAP_me=$'\e[0m'       # end mode

# Fix incorrect terminal color signal.
export COLORFGBG='0;15'

# grep
typeset -ga grep_options
grep_options=( --color=auto -i )
export GREP_COLORS='ms=33:mc=00;31:sl=:cx=:fn=34:ln=01;33:bn=32:se=37'
alias grep='grep '${grep_options:+"${grep_options[*]}"}

# ipython
# Fix pagination bug.
alias ipython='env -u PAGER ipython --pdb'
