local ac = require 'anywise_compat'

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

ac.setup(textobjects)

require('anywise_reg').setup {
  operators = { 'y' },
  textobjects = textobjects,
  paste_keys = {
    ['p'] = 'p',
  },
  register_print_cmd = true,
}

ac.setmap('x', '"+', 'd')
ac.setmap('X', '"+', 'c')
-- cutlass-inspired
-- select mode missing
map('nx', 'x', '"+d')
map('n', 'xx', '"+dd')
map('nx', 'X', '"+c')

map('nx', 'c', '"_c')
map('n', 'cc', '"_S')
map('nx', 'C', '"_C')
map('nx', 'd', '"_d')
map('n', 'dd', '"_dd')
map('nx', 'D', '"_D')
map('v', 'p', '"_dp')
map('v', 'P', '"_dP')
map('n', '<c-v>', 'P')
map('v', '<c-v>', 'dp')
map('i', '<c-v>', '<esc>pa')
