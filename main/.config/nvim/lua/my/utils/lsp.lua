local M = {}

function M.format(bufnr)
  -- https://github.com/L3MON4D3/LuaSnip/issues/129
  vim.cmd 'LuaSnipUnlinkCurrent'

  if false then
    vim.lsp.buf.format {
      async = false,
      filter = function(client)
        if --[[ client.name == 'null-ls' or ]]
          client.name == 'prismals'
        then
          return true
        end
        return false
      end,
      bufnr = bufnr,
    }
  end
  if true then
    require('conform').format {
      async = false,
      buf = bufnr,
    }
  end
end

function M.get_cmp_capabilities()
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  local res = require('cmp_nvim_lsp').default_capabilities()
  res.textDocument.completion.completionItem.snippetSupport = true
  res.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return res
end

function M.get_cmp_capabilities_no_fold()
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  local res = require('cmp_nvim_lsp').default_capabilities()
  res.textDocument.completion.completionItem.snippetSupport = true
  res.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return res
end

M.flags = {
  -- debounce_text_changes = 200,
  -- allow_incremental_sync = true,
}

function M.start_client(name)
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  require('lspconfig')[name].setup {
    capabilities = capabilities,
    filetypes = { 'html', 'css', 'typescriptreact', 'javascriptreact' },
  }
end

function M.get_client(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == name then
      return client
    end
  end
end

function M.toggle_client(name)
  local client = M.get_client(name)
  if client then
    client.stop()
  else
    M.start_client(name)
  end
end

return M
