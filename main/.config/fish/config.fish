#abbr -g ytdl 'youtube-dl -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.(ext)s"'
alias gh-token 'export GITHUB_TOKEN=(pass github.com/prncss-xyz|tail -1)'
abbr -g gncc 'commit -a --allow-empty-message -m ""'
fish_vi_key_bindings
alias o opener
alias e $EDITOR
alias bat 'bat --style=changes,header,rule,snip'
alias ls lsd
alias wttr 'curl "fr.wttr.in/montreal?n"'
alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvr /tmp/tree.json'
alias copy-last 'history|head -1|wl-copy'
alias plopg 'plop --plopfile="$HOME/Media/Projects/plopg/plopfile.js" --dest=.'
alias goldendict 'QT_QPA_PLATFORM=xcb goldendict'
alias nod 'nodemon --config ~/.config/nodemon/config.json'

starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# FIXME not working (from official exemple: https://fishshell.com/docs/current/cmds/bind.html)
bind \cg 'git diff; commandline -f repaint'
bind \cf f

function fish_title
  if  set -q TERMINUSOPEN
    echo (basename $PWD)"/"
  else
    set pat (realpath --relative-base=$HOME $PWD)
    if [ "$pat" = "." ]
      set pat "~"
    end
    set branch (git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]
      echo  " $branch — $pat"
    else
      echo $pat
    end
  end
end
