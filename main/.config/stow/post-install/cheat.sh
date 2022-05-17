#!/usr/bin/env sh

pip install virtualenv
curl https://cht.sh/:cht.sh > ~/.local/bin/cht
chmod +x ~/.local/bin/cht
cht --standalone-install --yes
