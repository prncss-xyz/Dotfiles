# shellcheck shell=sh
fisher update
nvim --headless +PackerInstall +qall
pnpm --global update
