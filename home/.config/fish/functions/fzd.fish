function fzd
  cd ~/stow
  set selected (fd --hidden --type=file --exclude=.git|fzf --history=$HOME/histories/fzd)
  if test -n "$selected"
    echo $selected|xargs $EDITOR
  end
end
