#!/usr/bin/env sh

# install nvim language files
mkdir -p ~/.local/share/nvim/site/spell/
curl "https://ftp.nluug.nl/pub/vim/runtime/spell/{en,fr}.utf-8.{spl,sug}" --output "#1.utf-8.#2" --output-dir ~/.local/share/nvim/site/spell

# let Packer initialize stuff
nvim --headless +PackerInstall +qall
