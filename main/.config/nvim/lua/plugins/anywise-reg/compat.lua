local M = {}

-- not actually in use, planning to reintroduce later

-- adapted from
-- https://github.com/AckslD/nvim-anywise-reg.lua/blob/927530fccb7b01b81eb4b39a12cc624ddf9d31e1/lua/anywise_reg/config.lua

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

-- adapted from
-- https://github.com/AckslD/nvim-anywise-reg.lua/blob/927530fccb7b01b81eb4b39a12cc624ddf9d31e1/lua/anywise_reg/keybinds.lua

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

local to

function M.setup(textobjects)
  to = expand_textobjects(textobjects)
end

function M.setup_yank_keymap(opl, prefix, opr)
  for _, textobject in ipairs(to) do
    local lhs = opl .. textobject
    local rhs = '<Cmd>lua require("anywise_reg.keybinds").perform_action('
      .. format_str_args { prefix, opr, textobject }
      .. ')<CR>'
    set_keymap(lhs, rhs)
  end
end

function M.setmap(opl, prefix, opr)
  vim.cmd(
    string.format(
      'autocmd BufEnter * :lua require"anywise_compat".setup_yank_keymap(%q, %q, %q)',
      opl,
      prefix,
      opr
    )
  )
end

return M
