autocmd TermOpen * startinsert|setlocal nonumber

augroup focus
  au!
  au TabLeave * silent! :wa
  au FocusLost * silent! :wa
  au BufLeave * silent! :wa
augroup end

autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

autocmd BufWritePost ~/Dotfiles/all/.config/nvim/lua/plugins.lua PackerCompile

" Vista
" function! NearestMethodOrFunction() abort
"  return get(b:, 'vista_nearest_method_or_function', '')
" endfunction

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }


" not wrorking...
" let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_trailing_blankline_indent = v:false

command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" function! NewFilePrecmd()
"   let cwd = getcwd()
"   let s = substitute(expand("%"), l:cwd . "/" , "", "")
"   return ":tabe " . s . "/"
" endfunction
