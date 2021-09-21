# shellcheck shell=sh

sudo systemctl enable greetd
sudo systemctl enable bluetooth
sudo systemctl enable networkmanager
sudo systemctl enable avahi
sudo systemctl enable sshd
sudo systemctl enable earlyoom

systemctl --user enable psd
systemctl --user enable syncthing
systemctl --user enable udiskie

# gnome kept rewriting that file, which blocked stow
# cat > ~/.config/user-dirs.dirs << EOF
# XDG_DOWNLOAD_DIR="$HOME/Downloads"
# XDG_PICTURES_DIR="$HOME/Media/Pictures"
# XDG_TEMPLATES_DIR="$HOME/Templates"
# XDG_DESKTOP_DIR="$HOME/Desktop"
# XDG_PUBLICSHARE_DIR="$HOME/Public"
# XDG_DOCUMENTS_DIR="$HOME/Media/Documents"
# XDG_MUSIC_DIR="$HOME/Music"
# XDG_VIDEOS_DIR="$HOME/Videos"
# EOF

dir=$(mktemp -d)
cd "$dir" || exit 1
git clone https://github.com/rose-pine/Rose-Pine-GTK-3-Theme.git
cp -r Rose-Pine-GTK-3-Theme/Rose-Pine/ ~/.themes/
rm -rf "$dir"

#/usr/share/qutebrowser/scripts/dictcli.py install en-US
#/usr/share/qutebrowser/scripts/dictcli.py install fr-CA

gh completion -s fish >~/.config/fish/completions/gh.fish

#set NPM_PACKAGES "$HOME/.npm-packages"
#set PATH $PATH $NPM_PACKAGES/bin
#set MANPATH $NPM_PACKAGES/share/man $MANPATH

#broot --install

pnpm --global i @fsouza/prettierd bash-language-server create-react-app eslint_d gatsby inliner jest mathjs nodemon serve snowpack typescript typescript-language-server vim-language-server vscode-langservers-extracted yaml-language-server react react-dom eslint babel-eslint
# emmet-ls
# hbs-cli
# remark
# plop

fisher update

# install nvim language files
mkdir -p ~/.local/share/nvim/site/spell/
curl "https://ftp.nluug.nl/pub/vim/runtime/spell/{en,fr}.utf-8.{spl,sug}" --output "#1.utf-8.#2" --output-dir ~/.local/share/nvim/site/spell
nvim --headless +PackerInstall +qall
