#!/usr/bin/env sh
# There are many projects named yq, this script refers to this one https://github.com/kislyuk/yq

EXCLUDE=venus
# EXCLUDE=""

NEW_CONF_IN="~/.config/syncthing/config.xml"
OLD_CONF_IN="/home/$USER-old/.config/syncthing/config.xml"
CONF_OUT="/tmp/syncthing-init-config.xml"
VERSION=$(xq '.configuration."@version"' "$NEW_CONF_IN")
echo "<configuration version=$VERSION>" > "$CONF_OUT"
xq -x 'del(.configuration."@version").configuration|del(.folder)' "$NEW_CONF_IN"  >> "$CONF_OUT"
xq -x '({folder: .configuration.folder}, {device: (.configuration.device|map(select(."@name" != $name)))})' "$OLD_CONF_IN" --arg name "$EXCLUDE" >> "$CONF_OUT"
echo "</configuration>" >> "$CONF_OUT"

mv "$NEW_CONF_IN" "$NEW_CONF_IN.bak"
mv "$CONF_OUT" "$NEW_CONF_IN"