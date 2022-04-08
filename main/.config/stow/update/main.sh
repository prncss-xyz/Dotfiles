#!/usr/bin/env sh

fisher update
nvim --headless +PackerInstall +qall
pnpm --global update
yay
