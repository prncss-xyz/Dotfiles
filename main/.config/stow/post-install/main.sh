# shellcheck shell=sh

systemctl --user start syncthing
# systemctl --user start psd
# systemctl --user start ssh-agent

dir=$(mktemp -d)
cd "$dir" || exit 1
git clone https://github.com/rose-pine/Rose-Pine-GTK-3-Theme.git
cp -r Rose-Pine-GTK-3-Theme/Rose-Pine/ ~/.themes/
rm -rf "$dir"
