source "$HOME/.profile"
eval "$(luarocks path --bin)"

[[ ! -o interactive ]] && return

export ZSH="$HOME/.local/share/sheldon/repos/github.com/ohmyzsh/ohmyzsh"
plugins=(dotenv zoxide fzf)

# Oh My Zsh settings here

eval "$(sheldon source)"

eval "$(starship init zsh)"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

alias c='bat --style=changes,header,rule,snip'
# alias e='exec $VISUAL'
#
alias e=nvr_do
alias f=fsearch-ext
alias gca='git add --all; git commit --allow-empty-message -m ""'
alias mkdir='mkdir -p'
alias mh='man -H'
alias n=nvim
alias o=xdg-open
alias l='exa --icons --git'
# alias plopg 'plop --plopfile="$HOME/Projects/plopg/plopfile.js" --dest=.'
# alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvim /tmp/sway-tree.json'
alias t='exa --icons --git --tree'
alias y='yt-dlp -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.%(ext)s"'
alias x='cd "$(xplr --print-pwd-as-result)"'
alias yx='yt-dlp -x'
alias ze='zk-bib eat --yes'

alias clock-in='echo i $(date +"%Y/%m/%d %H:%M:%S") >> ${TIMELOG}'
alias clock-out='echo o $(date +"%Y/%m/%d %H:%M:%S") >> ${TIMELOG}'
alias wasted='ledger -f ${TIMELOG} bal -b $(date -dlast-monday +%m/%d) --depth 2'
alias clock-status='[[ $(tail -1 ${TIMELOG} | cut -c 1) == "i" ]] && { echo "Clocked IN to $(tail -1 ${TIMELOG} | cut -d " " -f 4)"; } || { echo "Clocked OUT"; }' 

function _clock_in ()
{
    local cur prev
    _get_comp_words_by_ref -n : cur

    local words="$(cut -d ' ' -s -f 4 ${TIMELOG} | sed '/^$/d' | sort | uniq)"
    COMPREPLY=($(compgen -W "${words}" -- ${cur}))
    __ltrim_colon_completions "${cur}"
}
complete -F _clock_in clock-in

 cmd_to_clip () { wl-copy <<< $BUFFER }
 zle -N cmd_to_clip
 bindkey '^Y' cmd_to_clip

w-paste() {
    PASTE=$(wl-paste)
    LBUFFER="$LBUFFER${RBUFFER:0:1}"
    RBUFFER="$PASTE${RBUFFER:1:${#RBUFFER}}"
}
zle -N w-paste
bindkey '^V' w-paste

__my-exa() {
  echo
  exa --icons --git
  echo
  echo
  zle reset-prompt
}
zle -N __my-exa
bindkey '\el' __my-exa

__my-zi() {
  result="$(\command zoxide query -i -- "$@")" && __zoxide_cd "${result}"
  zle reset-prompt
}
zle -N __my-zi
bindkey '\ez' __my-zi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/prncss/google-cloud-sdk/path.zsh.inc' ]; then . '/home/prncss/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/prncss/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/prncss/google-cloud-sdk/completion.zsh.inc'; fi
