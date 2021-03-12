npm config set prefix ~/.node_modules
mkdir -p ~/.pnpm-pacakges
npm set location ~/.pnpm-packages
pnpm install-completion fish

pnpm i -g \
  bash-language-server \ 
  inliner \
  jest \
  mathjs \
  nodemon \
  prettier \
  typescript \
  typescript-language-server \
  vim-language-server \
  vscode-html-languageserver-bin \
  vscode-json-languageserver \
  yaml-language-server \
  mathjs \
