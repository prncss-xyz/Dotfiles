local command = vim.api.nvim_create_user_command

command('D', function(a)
  loadstring(string.format('dump(%s)', a.args))()
end, { nargs = '*', desc = 'dump lua expr' })

command('R', function()
  vim.cmd 'update'
  vim.cmd 'source %'
  -- TODO: R if path
  -- TODO: PackerCompile if path
end, { nargs = 0 })

command('S', function()
  vim.cmd [[
    vsp
    wincmd h
    vertical resize 85
  ]]
end, { nargs = 0, desc = '85 chars vsplit' })

local function stop_by_name(name)
  local client = require('plugins.lsp.utils').get_client(name)
  if not client then
    return
  end
  vim.lsp.stop_client(client, true)
end

command('T', function()
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local ts_utils = require 'nvim-treesitter.ts_utils'
  line = line - 1
  local root = ts_utils.get_root_for_position(line, column)
  local node = root:descendant_for_range(line, column, line, column + 1)
  local named = root:named_descendant_for_range(line, column, line, column + 1)
  -- node:range()
  -- 0,0 based
  dump(named:type(), node:type(), ts_utils.get_vim_range { node:range() })
end, { nargs = 0 })

command('W', function()
  local context = require('hop.window').get_window_context()
  context = context[1].contexts[1]
  dump(context)
end, { nargs = 0 })
