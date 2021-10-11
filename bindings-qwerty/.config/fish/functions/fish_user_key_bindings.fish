# file:///usr/share/doc/fish/interactive.html
# file:///usr/share/doc/fish/cmds/bind.html
# https://github.com/fish-shell/fish-shell/tree/master/share/functions
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
    bind \el fish_list_current_token
    # bind --preset $argv -k sright forward-bigword
    # bind --preset $argv -k sleft backward-bigword
end

# \eo open in pager
# \ev edit command line
# \es prepend sudo
# \cc cancel line
# \cu
# \cw
# \cr search history

# home \ca
# end  \e
# left \b
# right \f

# bind \cr fzf-history-widget
# bind \ec fzf-cd-widget
