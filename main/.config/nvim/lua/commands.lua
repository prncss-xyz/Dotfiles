local utils = require 'modules.utils'
local command = utils.command

command('Dump', { nargs = 1 }, function(name)
  vim.cmd(string.format('lua require"modules.utils".dump(%s)', name))
end)

command('LaunchOSV', {}, function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    require('osv').launch { type = 'server', host = '127.0.0.1', port = 30000 }
  end
end)

command('EditSnippet', {}, function()
  local l = vim.bo.filetype
  if l == 'javascript' then
    l = 'javascript/javascript'
  end
  vim.cmd(
    string.format(
      ':edit %s/snippets/%s.json',
      utils.local_repo'friendly-snippets',
      l
    )
  )
end)

-- trying to figure it out
command('Conceal', {}, function()
  vim.cmd [[
    syntax match True "true" conceal cchar=⊤
    syntax match False "false" conceal cchar=⊥
      ]]
end)

-- require 'telescope/md'
