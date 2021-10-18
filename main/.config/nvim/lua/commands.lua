local utils = require 'utils'
local command = utils.command

command('ExportTheme', { nargs = 1 }, function(name)
  require('theme-exporter').export_theme(name)
end)

command('Lua', { nargs = 1 }, function(name)
  vim.cmd(string.format('lua require"utils".dump(%s)', name))
end)

command('GhostNvim', {}, function() end)

command('LaunchOSV', {}, function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    require('osv').launch { type = 'server', host = '127.0.0.1', port = 30000 }
  end
end)

command('EditSnippet', {}, function()
  vim.cmd(
    string.format(
      ':edit snippets/%s.json',
      utils.local_repo'friendly-snippets',
      vim.bo.filetype
    )
  )
end)

command('Conceal', {}, function()
  vim.cmd [[
    syntax match True "true" conceal cchar=⊤
    syntax match False "false" conceal cchar=⊥
      ]]
end)

-- require 'telescope/md'
