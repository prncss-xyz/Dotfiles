# https://fishshell.com/docs/current/cmds/bind.html
# fish_key_reader -- to get binding code

function fish_user_key_bindings
    fish_vi_key_bindings
    fzf_key_bindings
    bind -M insert \ca history-search-backward
    bind -M insert \cx history-search-forward
    bind -M insert \co accept-autosuggestion
end
