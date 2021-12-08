# file:///usr/share/doc/fish/interactive.html
# file:///usr/share/doc/fish/cmds/bind.html
# https://github.com/fish-shell/fish-shell/tree/master/share/functions
# fish_key_reader -- to get binding code

function fish_user_key_bindings
    fzf_key_bindings
    bind \cg prevd-or-backward-word
    bind \ch nextd-or-forward-word
    bind \cj history-token-search-backward
    bind \cx history-token-search-forward
    # \ec fzf-cd-widget
    bind \ed fzf-file-widget
    bind \eh fish_man_page_html
    bind \el fish_list_current_token
    # \eo open in pager
    # \es prepend sudo
    # bind \cs edit command line
    # \cr fzf-history-widget
    # bind \cs pet-select
    bind \cs my_edit_command_buffer
    bind \ct transpose-chars
    # \cu kill to bol
    # \cv paste
    # \cw kill to bow
    bind \cy fish_clipboard_copy
    # \cz undo
end
