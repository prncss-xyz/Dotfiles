printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

#abbr -g ytdl 'youtube-dl -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.(ext)s"'
abbr -g gncc 'commit -a --allow-empty-message -m ""'
abbr -g kdiff kitty +kitten diff
fish_vi_key_bindings
alias o opener
alias bat 'bat --style=changes,header,rule,snip'
alias ls lsd
alias wttr 'curl "fr.wttr.in/montreal?n"'
alias get-tree 'swaymsg -t get_tree > /tmp/tree.json; nvr /tmp/tree.json'
alias clip-last 'history|head -1|wl-copy'
alias plopg 'plop --plopfile="$HOME/Media/Projects/plopg/plopfile.js" --dest=.'
alias goldendict 'QT_QPA_PLATFORM=xcb goldendict'

starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true


function fish_title
  if  set -q VIMRUNTIME
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
