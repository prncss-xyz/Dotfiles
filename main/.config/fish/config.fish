set fish_greeting # suppress greetings 
alias ght 'export GITHUB_TOKEN=(pass github.com/prncss-xyz|tail -1)'
abbr -g gncc 'commit -a --allow-empty-message -m ""'
alias o xdg-open
# alias e nvr -s
alias y 'youtube-dl -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.%(ext)s"'
alias e nvim_sessions
# alias e 'nvim --startuptime /tmp/nvim-startuptime'
alias s fsearch-ext
alias c 'bat --style=changes,header,rule,snip --color=always'
alias l 'exa --icons --git'
alias t 'exa --icons --git --tree'
alias m nvim_pager
# alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvim /tmp/sway-tree.json'
# alias plopg 'plop --plopfile="$HOME/Media/Projects/plopg/plopfile.js" --dest=.'
alias nod 'nodemon --config ~/.config/nodemon/config.json'
abbr hm 'man -H'

starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source
# pnpm: tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true# Get the colors in the opened man page itself
