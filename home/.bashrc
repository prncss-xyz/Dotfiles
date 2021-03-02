#
# ~/.bashrc
#

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]; then
  exec fish
else
  alias ls='ls --color=auto'
  PS1='[\u@\h \W]\$ '
fi

