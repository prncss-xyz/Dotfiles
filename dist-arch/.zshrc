export DOTFILES=$HOME/Dotfiles
export PROJECTS=$HOME/Projects

# gpg-connect-agent --quiet /bye >/dev/null 2>/dev/null
gpg-agent --daemon --quiet --enable-ssh-support >/dev/null 2>&1
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
export GPG_TTY=$(tty)

# micromamba
# export MAMBA_EXE=/usr/bin/micromamba
export MAMBA_ROOT_PREFIX=$HOME/micromamba

# uniduck
export UNIDUCK_DIR=$HOME/Media/uniduck

# nvim
export EXTENSION_TAGS=EXTENSION_TAGS # markdown tree-sitter compile flag // https://github.com/MDeiml/tree-sitter-markdown
export EXTENSION_WIKI_LINK=EXTENSION_WIKI_LINK
export EDITOR=nvim
export REACT_EDITOR=nvim # https://react-dev-inspector.zthxxx.me

# fzf
export FZF_CTRL_T_COMMAND='sfd --type file --follow --hidden --exclude .git $dir'
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)'"

# pass
export PASSWORD_STORE_CHARACTER_SET="a-zA-Z0-9~!\@#\$%^&*()-_=+[]{};:,.<>?"
export PASSWORD_STORE_DIR=$HOME/Personal/pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_GENERATED_LENGTH=20

# ledger
export LEDGER_FILE=$HOME/Personal/zk/p/current.journal
export TIMELOG="$ZK_NOTEBOOK_DIR/time.ledger"

# rg
export RIPGREP_CONFIG_PATH=$HOME/.config/rg/config

# zk
export ZK_NOTEBOOK_DIR=$HOME/Personal/zk

# xplr
export PATHMARKS_FILE=$HOME/Personal/xplr_bookmarks
export XPLR_BOOKMARK_FILE=$HOME/Personal/xplr-bookmarks

# export OPENAI_API_KEY=$(pass show openai.com/princesse@princesse.xyz|tail -1)
# export GITHUB_TOKEN=$(pass github.com/prncss-xyz|tail -1)

[[ ! -o interactive ]] && return
# ~/.zshrc

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
alias gh 'GITHUB_TOKEN=$(pass github.com/prncss-xyz|tail -1) gh'
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
