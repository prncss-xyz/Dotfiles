#!/usr/bin/env sh

dir=$(mktemp -d)
cd "$dir" || exit 1
git clone https://github.com/rose-pine/Rose-Pine-GTK-3-Theme.git
cp -r Rose-Pine-GTK-3-Theme/Rose-Pine/ ~/.themes/
rm -rf "$dir"
