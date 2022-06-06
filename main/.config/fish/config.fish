set fish_greeting # suppress greetings 

alias c 'bat --style=changes,header,rule,snip'
alias d zi
alias e nvim_session
alias e 'nvim --startuptime /tmp/nvim-startuptime'
# alias e nvr_do
alias f fsearch-ext
alias gh 'GITHUB_TOKEN=(pass github.com/prncss-xyz|tail -1) /usr/bin/gh '
abbr -g gncc 'commit -a --allow-empty-message -m ""'
abbr hm 'man -H'
alias l 'exa --icons --git'
alias nod 'nodemon --config ~/.config/nodemon/config.json'
alias o xdg-open
# alias plopg 'plop --plopfile="$HOME/Media/Projects/plopg/plopfile.js" --dest=.'
# alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvim /tmp/sway-tree.json'
alias t 'exa --icons --git --tree'
alias y 'yt-dlp -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.%(ext)s"'
abbr yx 'yt-dlp -x'
abbr rmt 'read-meta'
abbr rmtp 'read-meta papis'
abbr rmte 'read-meta epub'
abbr rmtm 'read-meta meta'

update_cwd_osc # this is needed beacause aur package sets TERM to 'foot-extra' and not 'foot'

starship init fish | source
zoxide init fish | source
# kitty + complete setup fish | source

# pnpm: tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true# Get the colors in the opened man page itself

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
set -gx MAMBA_EXE "/usr/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "/home/prncss/micromamba"
eval "/usr/bin/micromamba" shell hook --shell fish --prefix "/home/prncss/micromamba" | source
# <<< mamba initialize <<<
complete -c cht -xa '(cht :list)'
