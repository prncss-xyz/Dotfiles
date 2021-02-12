# shared with normal user
starship init fish | source
set -U fish_user_paths ~/bin/
fish_vi_key_bindings
bind -M insert \ej history-token-search-backward
bind -M insert \ek history-token-search-forward
bind -M insert \e'l' end-of-line
