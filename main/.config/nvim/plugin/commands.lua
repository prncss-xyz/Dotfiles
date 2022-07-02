local command = vim.api.nvim_create_user_command

command('Dump', function(a)
  loadstring(string.format('dump(%s)', a.args))()
end, { nargs = '*', desc = 'dump lua expr' })

command('PutText', function(a)
  loadstring(
    string.format('require"plugins.binder.actions".put_text(%s)', a.args)
  )()
end, { nargs = '*', desc = 'dump lua expr in buffer' })

command('Reload', function()
  vim.cmd 'update'
  vim.cmd 'source %'
end, { nargs = 0 })

command('NodeInfo', function()
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local ts_utils = require 'nvim-treesitter.ts_utils'
  line = line - 1
  local root = ts_utils.get_root_for_position(line, column)
  if root then
    local node = root:descendant_for_range(line, column, line, column + 1)
    local named = root:named_descendant_for_range(
      line,
      column,
      line,
      column + 1
    )
    -- node:range()
    -- 0,0 based
    dump(named:type(), node:type(), ts_utils.get_vim_range { node:range() })
  else
    print 'not supported for this filetype'
  end
end, { nargs = 0 })

command('WinInfo', function()
  local context = require('hop.window').get_window_context()
  context = context[1].contexts[1]
  dump(context)
end, { nargs = 0 })

command('LaunchOSV', function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    -- require('osv').run_this()
    require('osv').launch {
      type = 'server',
      host = '127.0.0.1',
      port = 30000,
    }
  end
end, { nargs = 0 })

