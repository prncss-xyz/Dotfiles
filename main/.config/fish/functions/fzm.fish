function fzm
  set selected (fd -e md -I --type=file|fzf)
  if test -n "$selected"
    mdopen "$selected"
  end
end
