starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source
set -U fish_user_paths ~/bin:(pnpm get location):(yarn global bin)
set -U fish_greeting
alias ls lsd
alias wttr 'curl "fr.wttr.in/montreal?n"'
alias get_gree 'swaymsg -t get_tree > /tmp/tree.json && browser /tmp/tree.json'
alias cp-last 'history|head -1|wl-copy'
function pnpm
  command pnpm $argv|lolcat
end
# set -x LANG en_US.utf8
# set -x QT_QPA_PLATFORM wayland
# set STARDICT_DATA_DIR Personal/stardict
# set -x BROWSER qutebrowser
#set -x BROWSER browser
#set -x EDITOR nvim
#set -x VISUAL nvim
#set -x DIFFPROG nvim -d
#set -x LC_COLLATE "C"
#set -x YTDL "$HOME/Music/ytdl"
#set -x PASSWORD_STORE_DIR ~/Personal/pass

# nnn
#set -x NNN_TRASH 1  
#set -x NNN_FIFO '/tmp/nnn.fifo'
#set -x NNN_OPENER '/usr/share/nnn/plugins/nuke'
#set -x NNN_BMS \
#"w:"(xdg-user-dir DOWNLOAD)\;\
#"p:"(xdg-user-dir PICTURES)\;\
#"d:"(xdg-user-dir DOCUMENTS)\;\
#"m:"(xdg-user-dir MUSIC_DIR)\;\
#"v:"(xdg-user-dir VIDEOS_DIR)\;\
#"u:"/run/media/$USER\;

# fzf
# set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
# set -U vscode_path "$HOME/.config/VSCodium"

function bcd -d 'cd backwards'
	pwd | awk -v RS=/ '/\n/ {exit} {p=p $0 "/"; print p}' | tac | fzf +m --select-1 --exit-0 | read -l result
	[ "$result" ]; and z $result
    ##	commandline -f repaint
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true
