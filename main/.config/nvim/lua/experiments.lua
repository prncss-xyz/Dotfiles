-- This is stuff we're trying to figure out
-- won't be sourced unless env NVIM_EXPERIMENTS is set to 'true'
-- can also be sourced manually


local augroup = require('utils').augroup
local command = require('utils').command

augroup('Illuminate', {
  {
    events = { 'VimEnter' },
    targets = { '*' },
    command = function()
      vim.cmd 'hi link illuminateWord cursorline'
    end,
  },
})

vim.cmd [[
augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi illuminatedCurWord cterm=italic gui=italic
augroup END
]]

-- trying to figure it out
command('Conceal', {}, function()
  vim.cmd [[
    syntax match True "true" conceal cchar=⊤
    syntax match False "false" conceal cchar=⊥
  ]]
end)

augroup('ConcealLua', {
  {
    events = { 'BufNewFile', 'BufRead' },
    targets = { '*.lua' },
    command = function()
      vim.cmd [[
        set syntax=on
        syntax match True "true" conceal cchar=⊤
        syntax match False "false" conceal cchar=⊥
      ]]
    end,
  },
})
augroup('ConcealLuaB', {
  {
    events = { 'FileType' },
    targets = { 'lua' },
    command = function()
      vim.cmd [[
        set syntax=on
        syntax match True "true" conceal cchar=⊤
        syntax match False "false" conceal cchar=⊥
      ]]
    end,
  },
})
