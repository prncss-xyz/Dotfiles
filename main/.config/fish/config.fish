set fish_greeting # suppress greetings
# set -x DOTFILES $HOME/Dotfiles
# set -x PASSWORD_STORE_CHARACTER_SET "a-zA-Z0-9~!\@#\$%^&*()-_=+[]{};:,.<>?"
# set -x PASSWORD_STORE_DIR $HOME/Personal/pass
# set -x PASSWORD_STORE_ENABLE_EXTENSIONS true
# set -x PASSWORD_STORE_GENERATED_LENGTH 20
# set -x FZF_CTRL_T_COMMAND "fd --type file --follow --hidden --exclude .git $dir"
# set -x FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"
# set -x FZF_DEFAULT_OPTS "--bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)'"
# set -x LEDGER_FILE $HOME/Personal/zk/p/current.journal
# set -x PROJECTS $HOME/Projects
# set -x RIPGREP_CONFIG_PATH $HOME/.config/rg/config
# set -x ZK_NOTEBOOK_DIR $HOME/Personal/zk

alias c 'bat --style=changes,header,rule,snip'
alias d zi
# alias e 'exec $VISUAL'
alias e nvr_do
alias n nvim
alias f fsearch-ext
alias gh 'GITHUB_TOKEN=(pass github.com/prncss-xyz|tail -1) /opt/homebrew/bin/gh '
abbr -g gca 'git add --all; git commit --allow-empty-message -m ""'
abbr mh 'man -H'
alias l 'exa --icons --git'
alias nod 'nodemon --config ~/.config/nodemon/config.json'
alias o xdg-open
# alias plopg 'plop --plopfile="$HOME/Projects/plopg/plopfile.js" --dest=.'
# alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvim /tmp/sway-tree.json'
alias t 'exa --icons --git --tree'
alias y 'yt-dlp -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.%(ext)s"'
abbr yx 'yt-dlp -x'
abbr ze 'zk-bib eat --yes'

update_cwd_osc # this is needed beacause aur package sets TERM to 'foot-extra' and not 'foot'

# mcfly init fish | source
starship init fish | source
zoxide init fish | source
# kitty + complete setup fish | source

# pnpm: tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true # Get the colors in the opened man page itself

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
eval micromamba shell hook --shell fish --prefix /home/prncss/micromamba | source
eval (direnv hook fish)
# <<< mamba initialize <<<
set time date
