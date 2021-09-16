# https://fishshell.com/docs/current/cmds/bind.html

function fish_user_key_bindings
    fzf_key_bindings

    # not working
    bind \cn history-search-backward
    bind \cp history-search-forward
    bind \ca 'clear; commandline -f repaint; echo bind OK'
end
