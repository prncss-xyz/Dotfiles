abbr -g ytdl 'youtube-dl -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.(ext)s"'
abbr -g gncc 'commit -a --allow-empty-message -m ""'
abbr -g kdiff kitty +kitten diff
fish_vi_key_bindings
alias o opener
alias bat 'bat --style=changes,header,rule,snip'
alias ls lsd
alias wttr 'curl "fr.wttr.in/montreal?n"'
alias get_tree 'swaymsg -t get_tree > /tmp/tree.json; nvimpager /tmp/tree.json'
alias cp-last 'history|head -1|wl-copy'
alias plopg 'plop --plopfile="$HOME/Media/Projects/plopg/plopfile.js" --dest=.'

#function __nvr_hook --on-variable PWD
#  nvr --remote-send "<cmd>let b:pwd=\"$PWD\"<cr>"
#end

starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
