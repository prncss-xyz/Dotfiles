pnpm 

echo << EOF > ~/.profile
PATH="$HOME/.node_modules/bin:$PATH"
EOF

npm config set prefix ~/.node_modules
npm config set init-author-name "Juliette Lamarche"
npm config set init-author-email "juliette.lamarche@princesse.xyz"
npm config set init-author-url "https://github.com/prncss-xyz/"
mkdir -p ~/.pnpm-pacakges
npm set location ~/.pnpm-packages
pnpm install-completion fish

npm i -g \
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
  yaml-language-server
  pnpm
