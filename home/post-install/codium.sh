# code --list-extensions
# code --uninstall-extension $extension

for extension in \
  esbenp.prettier-vscode \
  GraphQL.vscode-graphql \
  mads-hartmann.bash-ide-vscode \
  ms-python.python \
  sumneko.lua \
  whatwedo.twig
do
  echo codium --install-extension $extension
done

# gregoire.dance
# ms-vscode.js-debug-nightly
# ms-vscode.vscode-typescript-tslint-plugin
# streetsidesoftware.code-spell-checker
# whtouche.vscode-js-console-utils
# wmaurer.change-case
# bengreenier.vscode-node-readme
# Orta.vscode-jest
