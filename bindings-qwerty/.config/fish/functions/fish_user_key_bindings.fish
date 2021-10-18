# file:///usr/share/doc/fish/interactive.html
# file:///usr/share/doc/fish/cmds/bind.html
# https://github.com/fish-shell/fish-shell/tree/master/share/functions
# fish_key_reader -- to get binding code

function fish_user_key_bindings
    # fish_vi_key_bindings
    fzf_key_bindings
    # bind \eb accept-autosuggestion
    bind \ef nextd-or-forward-word
    bind \eb prevd-or-backward-word
    bind \ep backward-bigword
    bind \en forward-bigword
    # bind \ca up-or-search
    # bind \cx down-or-search
    bind \eb backward-word
    bind \ef forward-word
    bind \ct transpose-chars
    bind \ed fzf-file-widget
    bind \cy fish_clipboard_copy
    bind \ch beginning-of-line
    bind \cs 'pet-select --layout=bottom-up'
    bind \eh fish_man_page_html
    bind \el fish_list_current_token
end

# \cb \cf back, forward
# \ca \ce home, end
# \cu \ck cut to bol, eol
# \cc kill line
# \cd del or quit


# \eo open in pager
# \ev edit command line
# \es prepend sudo
# \cc cancel line
# \cw

# bind \cr fzf-history-widget
# bind \ec fzf-cd-widget
