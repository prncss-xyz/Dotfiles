function fzd
  cd ~/Dotfiles-perso/
  set selected (fd --hidden --type=file --exclude=.git|fzf --history=$HOME/.histories/fzdp)
  if test -n "$selected"
    echo $selected|xargs $EDITOR
  end
end
