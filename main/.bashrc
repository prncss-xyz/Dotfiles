#
# ~/.bashrc
#

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# Workaround gdm overriding PATH
# this is a workaround for gdm messing with PATH
# see issue: https://gitlab.gnome.org/GNOME/gdm/-/issues/692
# setting gdm.conf option does not seem any more effective (under Wayland at least): https://www.jirka.org/gdm-documentation/x220.html

if [ -z "$NVIM_LISTEN_ADDRESS" ]; then
  export NVIM_LISTEN_ADDRESS="/tmp/nvim-$$.sock"
fi

eval "$(direnv hook bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]; then
	exec fish
fi
