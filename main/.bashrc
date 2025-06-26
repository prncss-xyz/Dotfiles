# If not running interactively, don't do anything
. "$HOME/.profile"

[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/prncss/.lmstudio/bin"
