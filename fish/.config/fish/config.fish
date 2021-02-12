starship init fish | source
set -U fish_user_paths (yarn global bin):"$HOME"/bin
set -U fish_greeting
fish_vi_key_bindings
bind -M insert \ej history-token-search-backward
bind -M insert \ek history-token-search-forward
bind -M insert \e'l' end-of-line
# set -x LANG en_US.utf8
# set -x QT_QPA_PLATFORM wayland
# set STARDICT_DATA_DIR Personal/stardict
# set -x BROWSER qutebrowser
set -x BROWSER firefox
set -x EDITOR nvim
set -x VISUAL nvim
set -x DIFFPROG nvim -d
set -x NNN_TRASH 1  
set -x NNN_PLUG 'd:diffs;o:fzopen;.:dotdiff;m:nmount;l:launch'
set -x LC_COLLATE "C"
set -x NNN_BMS \
"w:"(xdg-user-dir DOWNLOAD)\
";p:"(xdg-user-dir PICTURES)\
";t:"(xdg-user-dir TEMPLATES)\
";d:"(xdg-user-dir DOCUMENTS)\
";m:"(xdg-user-dir MUSIC_DIR)\
";v:"(xdg-user-dir VIDEOS_DIR)
set -x YTDL "$HOME/Music/ytdl"
alias hman "man -H$BROWSER"
alias lifxc "nvim ~/Personal/Projects/lifx/index.js"
alias lifx "node ~/Personal/Projects/lifx"
alias ffzf "nvim (fzf)"
