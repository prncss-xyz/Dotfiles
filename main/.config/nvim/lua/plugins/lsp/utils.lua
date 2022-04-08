local utils = require 'utils'
local command = utils.command

function get_lsp_client(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == name then
      return client
    end
  end
end

function stop_by_name(name)
  local client = M.get_client(name)
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
