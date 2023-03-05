local M = {}

function M.format(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      if client.name == 'null-ls' then
        return true
      end
      return false
    end,
    bufnr = bufnr,
  }
end

function M.on_attach(client, _) end

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

M.flags = {
  debounce_text_changes = 200,
  allow_incremental_sync = true,
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
