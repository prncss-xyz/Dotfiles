# https://fishshell.com/docs/current/cmds/bind.html
# fish_key_reader -- to get binding code

function fish_user_key_bindings
    # fish_vi_key_bindings
    fzf_key_bindings
    # bind \eb accept-autosuggestion
    bind \ci nextd-or-forward-word
    bind \co prevd-or-backward-word
    bind \ca up-or-search
    bind \cx down-or-search
    bind \eb backward-word
    bind \ef forward-word
    bind \ct transpose-chars
    bind \ee fzf-file-widget
    bind \cy fish_clipboard_copy
    bind \ch beginning-of-line
    bind \cs 'pet-select --layout=bottom-up'
    bind \eh fish_man_page_html
    # bind --preset $argv -k sright forward-bigword
    # bind --preset $argv -k sleft backward-bigword
end

# bind \cr fzf-history-widget
# bind \ec fzf-cd-widget
