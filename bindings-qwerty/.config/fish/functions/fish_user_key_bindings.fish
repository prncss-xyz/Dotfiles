# file:///usr/share/doc/fish/interactive.html
# file:///usr/share/doc/fish/cmds/bind.html
# https://github.com/fish-shell/fish-shell/tree/master/share/functions
# fish_key_reader -- to get binding code

function fish_user_key_bindings
    fzf_key_bindings
    bind \eb prevd-or-backward-word
    # \ec fzf-cd-widget
    bind \ed fzf-file-widget
    bind \ef nextd-or-forward-word
    bind \eh fish_man_page_html
    bind \el fish_list_current_token
    bind \en forward-bigword
    # \eo open in pager
    bind \ep backward-bigword
    # \es prepend sudo
    # \ev edit command line

    # \ca to bol
    # \cb back
    # \cc cancel line
    # \cd del or quit
    # \ce to eol
    # \cf forward
    bind \ch beginning-of-line
    # \ck kill to eol
    # \cl repaint
    # \cm up-or-search # bind
    # \cn down-or-search # bind
    # \cr fzf-history-widget
    bind \cs 'pet-select --layout=bottom-up'
    bind \ct transpose-chars
    # \cu kill to bol
    # \v paste
    # \cw kill to bow
    bind \cy fish_clipboard_copy
    # \cz undo
end
