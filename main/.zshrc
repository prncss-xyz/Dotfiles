if [[ Darwin -eq $(uname -s) ]]
then
  export PATH=$HOME/.local/bin:/usr/bin/vendor_perl:$HOME/.pnpm-global-bin:$HOME/.cargo/bin:$HOME.luarocks/bin:$PATH:$HOME/.local/share/gem/ruby/3.0.0
  export PATH=$HOME/bin:/usr/local/bin:$PATH
  export DOTFILES=$HOME/Dotfiles
  export PROJECTS=$HOME/Projects

  # micromamba
  # export MAMBA_EXE=/usr/bin/micromamba
  export MAMBA_ROOT_PREFIX=$HOME/micromamba

  # uniduck
    export UNIDUCK_DIR=$HOME/Media/uniduck

  # gpg
  gpg-connect-agent --quiet /bye >/dev/null 2>/dev/null
  gpg-agent --daemon --quiet --enable-ssh-support >/dev/null 2>&1
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export GPG_TTY=$(tty)
  export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

  # nvim
  export EXTENSION_TAGS=EXTENSION_TAGS # markdown tree-sitter compile flag // https://github.com/MDeiml/tree-sitter-markdown
  export EDITOR=nvim

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

  # rg
  export RIPGREP_CONFIG_PATH=$HOME/.config/rg/config

  # zk
  export ZK_NOTEBOOK_DIR=$HOME/Personal/zk

  # xplr
  export PATHMARKS_FILE=$HOME/Personal/xplr_bookmarks
  export XPLR_BOOKMARK_FILE=$HOME/Personal/xplr-bookmarks
fi

[[ ! -o interactive ]] && return

if [[ 0 -eq 0 ]]
then

  echo 'zsh'
# oh-my-zsh

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/olets/zsh-abbr.git  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-abbr
# abbr pn='pnpm'
# abbr mh="man -H"
# abbr yx="yt-dlp -x"
# abbr ze="zk-bib eat --yes"

export ZSH="$HOME/.oh-my-zsh"
plugins=(   
  docker
  docker-compose
  dotenv
  gh
  git 
  man
  node
  pass
  ripgrep
  sudo
  web-search
  zoxide

  zsh-abbr
  zsh-autosuggestions
  zsh-syntax-highlighting 
)
source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

alias c='bat --style=changes,header,rule,snip'
alias d=zi
# alias e='exec $VISUAL'
alias e=nvr_do
alias f=fsearch-ext
alias gh='GITHUB_TOKEN=$(pass github.com/prncss-xyz|tail -1) /opt/homebrew/bin/gh '
alias gca='git add --all; git commit --allow-empty-message -m ""'
alias mkdir='mkdir -p'
alias n=nvim
alias l='exa --icons --git'
# alias plopg 'plop --plopfile="$HOME/Projects/plopg/plopfile.js" --dest=.'
# alias sway-tree 'swaymsg -t get_tree > /tmp/sway-tree.json; nvim /tmp/sway-tree.json'
alias t='exa --icons --git --tree'
alias y='yt-dlp -x -o "~/Media/Music/ytdl/%(artist)s %(title)s.%(ext)s"'
alias x='cd "$(xplr --print-pwd-as-result)"'
# alias o=xdg-open

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

else
exec fish
fi
