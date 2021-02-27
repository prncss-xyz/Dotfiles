#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export MOZ_ENABLE_WAYLAND=1
export BROWSER=~/browser
export EDITOR=nvim
export VISUAL=nvim
export DIFFPROG="nvim -d"
export LC_COLLATE=C
export YTDL=~/Music/ytdl
export PASSWORD_STORE_DIR=~/Personal/pass

# nnn
export NNN_TRASH=1  
export NNN_FIFO=/tmp/nnn.fifo
export NNN_OPENER=/usr/share/nnn/plugins/nuke
export NNN_BMS=\
"w:$(xdg-user-dir DOWNLOAD);"\
"p:$(xdg-user-dir PICTURES);"\
"d:$(xdg-user-dir DOCUMENTS);"\
"m:$(xdg-user-dir MUSIC_DIR);"\
"v:$(xdg-user-dir VIDEOS_DIR);"\
"u:/run/media/$USER;"
export NNN_PLUG='d:diffs;o:fzopen;O:fzopend;a:preview-tui;k:kdeconnect;c:fzcd;z:autojump;t:-_|kitty;'

# codium
export vscode_path=~/.config/VSCodium
 

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
then
	exec fish
fi
