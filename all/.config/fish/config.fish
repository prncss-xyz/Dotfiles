starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source

abbr -g ytdl 'youtube-dl -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.(ext)s"'
abbr -g gncc 'commit -a --allow-empty-message -m ""'
abbr -g kdiff kitty +kitten diff

alias bat 'bat --style=changes,header,rule,snip'
alias ls lsd
alias wttr 'curl "fr.wttr.in/montreal?n"'
alias get_tree 'swaymsg -t get_tree > /tmp/tree.json && browser /tmp/tree.json'
alias cp-last 'history|head -1|wl-copy'
alias imgs 'swaymsg -t get_tree | jq \'recurse(.nodes[])|.name\' | sed -n \'s/imv - .* \(\/.*\) \[.*\] /\1/p\''
alias plopg 'plop --plopfile="$HOME/Media/Projects/plopg/plopfile.js" --dest=.'
function pnpm
  command pnpm $argv|lolcat
end

function bcd -d 'cd backwards'
	pwd | awk -v RS=/ '/\n/ {exit} {p=p $0 "/"; print p}' | tac | fzf +m --select-1 --exit-0 | read -l result
	[ "$result" ]; and z $result
    ##	commandline -f repaint
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true
