export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
export GPG_TTY=$(tty)
eval "$(luarocks path --bin)"
eval "$(direnv hook zsh)"

[[ ! -o interactive ]] && return

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
eval "$(sheldon source)"
# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

alias tt="node $HOME/Projects/github.com/prncss-xyz/tags/dist/index.js"
alias ttt="TEST=TEST node $HOME/Projects/github.com/prncss-xyz/tags/dist/index.js"
alias sg=ast-grep
alias c='bat --style=changes,header,rule,snip'
alias e=nvr_do
alias f=fsearch-ext
alias gca='git add --all; git commit --allow-empty-message -m ""'
alias mkdir='mkdir -p'
alias mh='man -H'
# workaround for avante
alias n='TALIVY_API_KEY=$(pass show tavily.com/juliette.lamarche.xyz@gmail.com/keys/nvim) nvim'
alias n2='NVIM_APPNAME=nvim2 nvim'
alias nvc='NVIM_APPNAME=nvim-code nvim'
alias o=xdg-open
alias l='eza --icons --git'
# alias plopg 'plop --plopfile="$HOME/Projects/plopg/plopfile.js" --dest=.'
# alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvim /tmp/sway-tree.json'
alias t='eza --icons --git --tree'
alias ytx='yt-dlp -x'
alias yta='yt-dlp -x --output "%(autonumber)02d %(title)s.%(ext)s"'
alias ze='zk-bib eat --yes'
alias yayy='yay --noconfirm '

 cmd_to_clip () { wl-copy <<< $BUFFER }
 zle -N cmd_to_clip
 bindkey '^Y' cmd_to_clip

w-paste() {
    PASTE=$(wl-paste)
    LBUFFER="$LBUFFER${RBUFFER:0:1}" RBUFFER="$PASTE${RBUFFER:1:${#RBUFFER}}"
}
zle -N w-paste
bindkey '^V' w-paste

__my-eza() {
  echo
  eza --icons --git
  echo
  echo
  zle reset-prompt
}
zle -N __my-eza
bindkey '\el' __my-eza

__my-zi() {
  result="$(\command zoxide query -i -- "$@")" && __zoxide_cd "${result}"
  zle reset-prompt
}
zle -N __my-zi
bindkey '\eo' __my-zi

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

