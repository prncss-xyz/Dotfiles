# help interactive
# help bind

# https://github.com/fish-shell/fish-shell/tree/master/share/functions
# fish_key_reader -- to get binding code

function fish_user_key_bindings
    fzf_key_bindings
    bind \eb prevd-or-backward-word
    bind \ed kill-word
    # \ee edit_command_buffer
    bind \ef nextd-or-forward-word
    bind \el fish_list_current_token
    # \eo open in pager
    # \es prepend sudo

    bind \cg fzf-file-widget
    bind \ch fish_man_page_html
    # TODO: token search when line not empty
    # bind \cm history-token-search-backward
    # bind \cn history-token-search-forward
    bind \co popd
    # bind \cp history-token-search-backward
    bind \cq 'pushd .'
    # bind fzf-cd-widget
    # bind \cr fzf-history-widget
    bind \cr __mcfly-history-widget
    # \cu kill to bol
    # \cv paste
    # \cw kill to bow
    bind \cy fish_clipboard_copy
    # \cz undo
end
