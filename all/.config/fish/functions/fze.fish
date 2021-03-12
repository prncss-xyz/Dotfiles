function fze
  set selected (fd --type=file|fzf)
  if test -n "$selected"
    echo "$selected"|xargs $EDITOR
  end
end
