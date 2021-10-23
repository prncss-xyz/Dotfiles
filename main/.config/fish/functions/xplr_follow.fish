function xplr_follow #--wraps xplr --description 'support xplr quit and change directory'
    if [ -e /tmp/xplr.fifo ]
        cat /tmp/xplr.fifo | while read --line path
            echo $path >/tmp/xplr_focus
        end
        rm /tmp/xplr_focus
    end
end
