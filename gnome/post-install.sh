
for param in
do
  gsettings set $param
done

# gsettings get org.gnome.shell enabled-extensions
# gsettings list-recursively

# gsettings set org.gnome.desktop.background picture-uri 'file:///path/to/my/picture.jpg'
# gsettings set org.gnome.desktop.screensaver picture-uri 'file:///path/to/my/picture.jpg'
