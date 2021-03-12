# yarn global list depth=0
# export PATH="$(yarn global bin):$PATH"
# Running yarn create react-app will start by doing the same thing as yarn global add create-react-app.

yarn config set prefix ~/.yarn

yarn global add \
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
