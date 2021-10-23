function xplr_preview --argument-names path --description 'preview path in xplr\'s preview'jk
    if [ -e /tmp/xplr.fifo ]
      echo "focusing"
      echo (realpath "$path") >/tmp/xplr.fifo
    end
end
