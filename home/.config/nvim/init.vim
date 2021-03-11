if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'neovim/nvim-lsp'
  Plug 'nvim-lua/completion-nvim'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'prettier/vim-prettier'
"  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'jeffkreeftmeijer/vim-dim'
  Plug 'noahfrederick/vim-noctu'
  Plug 'matze/vim-move'
  Plug 'dag/vim-fish'
  Plug 'cespare/vim-toml'
call plug#end()

lua <<EOF
require'nvim_lsp'.tsserver.setup{}
require'nvim_lsp'.html.setup{}
require'nvim_lsp'.jsonls.setup{}
require'nvim_lsp'.vimls.setup{}
require'nvim_lsp'.yamlls.setup{}
--require'nvim_lsp'.pyls.setup{}
EOF

"if has_key(plugs, 'completion-nvim')
  autocmd BufEnter * lua require'completion'.on_attach()
"endif

syntax on
"set termguicolors
"colorscheme dim

"let g:airline_theme='base16_spacemacs'
"highlight SignColumn ctermbg=3

augroup focus
  au!
  au TabLeave * silent! :wa
  au FocusLost * silent! :wa
  au BufLeave * silent! :wa
augroup END
set noswapfile
set autoread
set autowriteall
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0
set undodir=~/.vim/undo
set undofile

autocmd TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

"autocmd Filetype javascript,javascriptreact,typescript,typescriptreact \
"  setlocal omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <c-s> :w<CR>
nnoremap <c-w> :q<CR>
inoremap <c-s> <Esc>:w<CR>a
vnoremap <c-s> <Esc>:w<CR> 
noremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
set colorcolumn=80
set smartcase

"let $NVIM_TUI_ENABLE_TRUE_COLOR=1






