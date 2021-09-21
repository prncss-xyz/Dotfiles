#
# ~/.bashrc
#

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '


# export GITHUB_TOKEN=$(pass github.com/prncss-xyz|tail -1)

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]; then
	exec fish
fi
