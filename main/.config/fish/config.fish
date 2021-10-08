set fish_greeting # suppress greetings 
alias ght 'export GITHUB_TOKEN=(pass github.com/prncss-xyz|tail -1)'
abbr -g gncc 'commit -a --allow-empty-message -m ""'
alias o opener
# alias e nvr -s
alias y 'youtube-dl -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.(ext)s"'
alias e 'nvim'
# alias e 'nvim --startuptime /tmp/nvim-startuptime'
alias s search-ext
alias bat 'bat --style=changes,header,rule,snip'
alias ls 'exa --icons --git'
alias t 'exa --icons --git --tree'
# alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvim /tmp/sway-tree.json'
# alias plopg 'plop --plopfile="$HOME/Media/Projects/plopg/plopfile.js" --dest=.'
alias nod 'nodemon --config ~/.config/nodemon/config.json'
abbr hm 'man -H'

starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_CTRL_T_COMMAND='fd --type file --follow --hidden --exclude .git --color=always $dir'
export FZF_DEFAULT_OPTS="--ansi"

# pnpm
# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

function fish_title
    if set -q TERMINUSOPEN
        echo (basename $PWD)"/"
    else
        set pat (realpath --relative-base=$HOME $PWD)
        if [ "$pat" = "." ]
            set pat "~"
        end
        set branch (git branch --show-current 2>/dev/null)
        if [ -n "$branch" ]
            echo "$pat — $branch"
            #      echo  " $branch — $pat"
        else
            echo $pat
        end
    end
end
