# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# if [ -z "$NVIM_LISTEN_ADDRESS" ]; then
export NVIM_LISTEN_ADDRESS="/tmp/nvim/$$"
# fi

echo $NVIM_LISTEN_ADDRESS

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]; then
  exec fish
fi
