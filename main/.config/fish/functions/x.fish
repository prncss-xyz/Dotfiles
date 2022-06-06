# Rename this file to match the name of the function
# e.g. ~/.config/fish/functions/f.fish
# or, add the lines to the 'config.fish' file.

# spawn xplr, execpt when inside a shell spawned from xplr, 
# then returns to xplr with current directory
# hence you will lose env variables set in that shell

function x --wraps xplr --description 'support xplr quit and change directory'
    echo -ne "\e]0;"
    echo -n "XPLR"
    echo -ne "\a"
    if test -n "$XPLR_PIPE_MSG_IN"
        # FIXME: get printf %q to work properly
        echo "ChangeDirectory: \"$PWD\"" >>$XPLR_PIPE_MSG_IN
        exit
    end
    set dest (xplr $argv)
    switch "$dest"
        case ""
        case "*"
            cd "$dest"
    end
end
