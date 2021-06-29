function fzm
  set selected (fd -L -e md -I --type=file|fzf)
  if test -n "$selected"
    opener "$selected"
  end
end
