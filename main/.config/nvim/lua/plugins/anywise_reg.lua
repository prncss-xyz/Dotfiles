
-- anywise-reg + cutlass
local function map(modes, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if modes == '' then
    vim.api.nvim_set_keymap('', lhs, rhs, options)
    return
  end
  for mode in modes:gmatch '.' do
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
end

local textobjects = {
  { 'i', 'a' },
  { 'w', 'W' },
}

local anywise = false
-- local opt = 'anywise'
local opt = 'caca'
if opt == 'anywise' then
  local ac = require 'anywise_compat'
  ac.setup(textobjects)
  require('anywise_reg').setup {
    operators = {},
    -- operators = { 'y' },
    textobjects = textobjects,
    paste_keys = {
      ['p'] = 'p',
    },
    register_print_cmd = true,
  }
  ac.setmap('y', '"+', 'y')
  ac.setmap('x', '"+', 'd')
  ac.setmap('X', '"+', 'c')
elseif opt == 'miniyank' then
  map('', 'p', '<Plug>(miniyank-autoput)', { noremap = false })
  map('', 'P', '<Plug>(miniyank-autoPut)', { noremap = false })
  map('', '<leader>r', '<Plug>(miniyank-cycle)', { noremap = false })
  map('', '<leader>R', '<Plug>(miniyank-cycleback)', { noremap = false })
  map('', '<leader>c', '<Plug>(miniyank-tochar)', { noremap = false })
  map('', '<leader>l', '<Plug>(miniyank-toline)', { noremap = false })
  map('', '<leader>b', '<Plug>(miniyank-toblock)', { noremap = false })
elseif opt == 'yoink' then
  vim.g.yoinkIncludeNamedRegisters = 0
  vim.g.yoinkIncludeDeleteOperations = 0
  map('', 'p', '<Plug>(YoinkPaste_p)', { noremap = false })
  map('', 'P', '<Plug>(YoinkPaste_P)', { noremap = false })
  map('', 'gp', '<Plug>(YoinkPaste_gp)', { noremap = false })
  map('', 'gP', '<Plug>(YoinkPaste_gP)', { noremap = false })
  map('', '<leader>r', '<plug>(YoinkPostPasteSwapBack)', { noremap = false })
  map('', '<leader>R', '<Plug>(YoinkPostPasteSwapForward)', { noremap = false })
  map('', '<leader>y', '<plug>(YoinkRotateBack)', { noremap = false })
  map('', '<leader>Y', '<Plug>(YoinkRotateForward)', { noremap = false })
end


-- cutlass-inspired
-- select mode missing
map('nx', 'x', '"+d')
map('n', 'xx', '"+dd')
map('nx', 'X', '"+d$')

map('nx', 'c', '"_c')
map('n', 'cc', '"_S')
map('nx', 'C', '"_C')
map('nx', 'd', '"_d')
map('n', 'dd', '"_dd')
map('nx', 'D', '"_D')
-- map('v', 'p', '"_dp')
-- map('v', 'P', '"_dP')
map('nv', '<c-v>', 'gp')
map('i', '<c-v>', '<esc>pa')
