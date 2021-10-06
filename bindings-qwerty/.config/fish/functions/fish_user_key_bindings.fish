# https://fishshell.com/docs/current/cmds/bind.html
# fish_key_reader -- to get binding code

function fish_user_key_bindings
    # fish_vi_key_bindings
    fzf_key_bindings
    bind -M insert \ca history-search-backward
    bind -M insert \cx history-search-forward
    bind -M insert \eo accept-autosuggestion
    bind -M insert \cf edit_command_buffer
    bind -M insert \ci nextd-or-forward-word
    bind -M insert \co prevd-or-backward-word
    bind -M insert \cn up-or-search
    bind -M insert \cp down-or-search
    bind -M insert \cb backward-word
    bind -M insert \ce forward-word
    # bind --preset $argv -k sright forward-bigword
    # bind --preset $argv -k sleft backward-bigword
end
