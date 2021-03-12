function fzw
  cd ~/Media/Web
  set selected (fd -e html --type=file|fzf --history=$HOME/histories/fzw)
  if test -n "$selected"
    echo $selected|xargs $BROWSER
  end 
end
