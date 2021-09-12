# shellcheck shell=sh

systemctl --user start syncthing
# systemctl --user start psd
# systemctl --user start ssh-agent

dir=$(mktemp -d)
cd "$dir" || exit 1
git clone https://github.com/rose-pine/Rose-Pine-GTK-3-Theme.git
cp -r Rose-Pine-GTK-3-Theme/Rose-Pine/ ~/.themes/
rm -rf "$dir"

#/usr/share/qutebrowser/scripts/dictcli.py install en-US
#/usr/share/qutebrowser/scripts/dictcli.py install fr-CA

systemctl --user enable ssh-agent.service
systemctl --user enable syncthing.service
systemctl --user enable udiskie.service

## pnpm
# none seem to work :-(, will retry on fresh install

# pnpm config set global-dir ~/.pnpm-packages
# pnpm config set set pnpm-prefix ~/.pnpm-packages
# pnpm config set set npm-prefix ~/.pnpm-packages

#set NPM_PACKAGES "$HOME/.npm-packages"
#set PATH $PATH $NPM_PACKAGES/bin
#set MANPATH $NPM_PACKAGES/share/man $MANPATH

#broot --install

mkdir ~/.pnpm-global
pnpm --global -i\
  @fsouza/prettierd\
  bash-language-server\
  create-react-app\
  eslint_d\
  gatsby\
  inliner\
  jest\
  mathjs\
  nodemon\
  plop\
  serve\
  snowpack\
  typescript\
  typescript-language-server\
  vim-language-server\
  vscode-langservers-extracted\
  yaml-language-server\

# emmet-ls
# hbs-cli
# remark

fisher update
nvim --headless +PackerInstall +qall
