function xplr_cd #--wraps xplr --description 'support xplr quit and change directory'
    if [ -f /tmp/xplr_focus ]
      cd (dirname (cat /tmp/xplr_focus))
    end
end
