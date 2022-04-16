" https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim

function! s:BlankUp() abort
  let cmd = 'put!=repeat(nr2char(10), v:count1)|silent '']+'
  if &modifiable
    let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-up)", v:count1)'
  endif
  return cmd
endfunction

function! s:BlankDown() abort
  let cmd = 'put =repeat(nr2char(10), v:count1)|silent ''[-'
  if &modifiable
    let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-down)", v:count1)'
  endif
  return cmd
endfunction

nnoremap <silent> <Plug>(unimpaired-blank-up)   :<C-U>exe <SID>BlankUp()<CR>
nnoremap <silent> <Plug>(unimpaired-blank-down) :<C-U>exe <SID>BlankDown()<CR>

