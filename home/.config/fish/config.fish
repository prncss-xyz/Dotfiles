starship init fish | source
zoxide init fish | source
kitty + complete setup fish | source
set -U fish_user_paths ~/.local/bin:(pnpm get location):(yarn global bin)
alias ls lsd
alias wttr 'curl "fr.wttr.in/montreal?n"'
alias get_tree 'swaymsg -t get_tree > /tmp/tree.json && browser /tmp/tree.json'
alias cp-last 'history|head -1|wl-copy'
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
