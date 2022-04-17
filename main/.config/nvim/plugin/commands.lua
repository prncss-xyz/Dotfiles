local command = require('utils').command

command('D', { nargs = 1 }, function(name)
  vim.cmd(string.format('lua dump(%s)', name))
end)

command('R', { nargs = 1 }, function(name)
  vim.cmd 'update'
  vim.cmd 'source %'
  -- TODO: R if path
  -- TODO: PackerCompile if path
end)

command('S', { nargs = 0 }, function()
  vim.cmd [[
    vsp
    wincmd h
    vertical resize 85
  ]]
end)

local function stop_by_name(name)
  local client = require('plugins.lsp.utils').get_client(name)
  if not client then
    return
  end
  vim.lsp.stop_client(client, true)
end

command('GrammarlyStop', {}, function()
  stop_by_name 'grammarly'
end)

command('GrammarlyStart', {}, function()
  local lspconfig = require 'lspconfig'
  lspconfig.grammarly.setup {}
end)
