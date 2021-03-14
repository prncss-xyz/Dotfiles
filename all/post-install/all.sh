dir=$(mktemp -d)
cd $dir
git clone --depth=1 https://aur.archlinx.org/yay.git
cd yay
makepkg -si
rm -rf $dir
cat yay | xargs yay --needed --noconfirm -S

fisher update

git config --global init.defaultBranch main
git config --global alias.nccommit 'commit -a --allow-empty-message -m ""'

nvim --headless +PlugInstall +qall

/usr/share/qutebrowser/scripts/dictcli.py install en-US
/usr/share/qutebrowser/scripts/dictcli.py install fr-CA

## VSCode

# code --list-extensions
# code --uninstall-extension $extension

for extension in \
  esbenp.prettier-vscode \
  GraphQL.vscode-graphql \
  mads-hartmann.bash-ide-vscode \
  ms-python.python \
  sumneko.lua \
  streetsidesoftware.code-spell-checker \
  whatwedo.twig
do
  echo codium --install-extension $extension
done

# gregoire.dance
# ms-vscode.vscode-typescript-tslint-plugin
# whtouche.vscode-js-console-utils
# wmaurer.change-case

systemctl --user enable ssh-agent.service
systemctl --user enable syncthing.service
systemctl --user enable udiskie.service
pacman -S --needed base-devel git stow

## pnpm
# none seem to work :-(, will retry on fresh install

pnpm config set global-dir ~/.pnpm-packages
pnpm config set set pnpm-prefix ~/.pnpm-packages
pnpm config set set npm-prefix ~/.pnpm-packages

#set NPM_PACKAGES "$HOME/.npm-packages"
#set PATH $PATH $NPM_PACKAGES/bin
#set MANPATH $NPM_PACKAGES/share/man $MANPATH

broot --install
