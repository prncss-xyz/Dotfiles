autocmd TermOpen * startinsert|setlocal nonumber|setlocal norelativenumber

augroup focus
  au!
  au TabLeave * silent! :wa
  au FocusLost * silent! :wa
  au BufLeave * silent! :wa
augroup end

autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

autocmd BufWritePost ~/Dotfiles/main/.config/nvim/lua/plugins.lua PackerCompile

command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
 
autocmd BufRead,BufNewFile **/.config/sway/* setfiletype i3
autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.htmlhintrc set filetype=json
autocmd FileType markdown LanguageToolSetUp
autocmd FileType markdown setlocal spell
autocmd BufWritePost * if &ft ==# 'markdown' | LanguageToolCheck | endif
