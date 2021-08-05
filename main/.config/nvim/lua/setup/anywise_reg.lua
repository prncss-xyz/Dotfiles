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

local function format_str_args(str_args)
  local args_str = ''
  for _, str_arg in ipairs(str_args) do
    args_str = args_str .. [[']] .. str_arg .. [[', ]]
  end
  return args_str:sub(1, -3)
end

local function set_keymap(lhs, rhs)
  local opts = { noremap = false }
  local mode = 'n'
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
end

local function product(textobjects)
  if textobjects[1] == nil then
    return { '' }
  end
  local textobject = table.remove(textobjects, 1)
  local expanded_textobjects = product(textobjects)
  local new_expanded_textobjects = {}
  for _, start in ipairs(textobject) do
    for _, rest in ipairs(expanded_textobjects) do
      table.insert(new_expanded_textobjects, start .. rest)
    end
  end
  return new_expanded_textobjects
end

local function expand_textobjects(textobjects)
  for i, textobject in ipairs(textobjects) do
    if type(textobject) == 'string' then
      textobjects[i] = { textobject }
    end
  end
  return product(textobjects)
end

local textobjects = {
  { 'i', 'a' },
  { 'w', 'W' },
}

local to = expand_textobjects(textobjects)
function _G.setup_yank_keymap(opl, prefix, opr)
  for _, textobject in ipairs(to) do
    local lhs = opl .. textobject
    local rhs = '<Cmd>lua require("anywise_reg.keybinds").perform_action('
      .. format_str_args { prefix, opr, textobject }
      .. ')<CR>'
    set_keymap(lhs, rhs)
  end
end

function _G.setmaps()
  setup_yank_keymap('x', '"+', 'd')
  setup_yank_keymap('X', '"+', 'c')
end

require('anywise_reg').setup {
  operators = { 'y' },
  textobjects = textobjects,
  paste_keys = {
    ['p'] = 'p',
  },
  register_print_cmd = true,
}

vim.cmd 'autocmd BufEnter * :lua _G.setmaps()'

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
map('n', '<c-v>', 'p')
map('v', '<c-v>', 'dp')
map('i', '<c-v>', '<esc>pa')
