local M = {}

function M.format(bufnr)
  -- https://github.com/L3MON4D3/LuaSnip/issues/129
  --[[ vim.cmd '!silent LuaSnipUnlinkCurrent' ]]

  local ft = vim.api.nvim_buf_get_option(bufnr or 0, 'ft')
  if
    false
    and vim.tbl_contains(
      { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      ft
    )
  then
    -- __AUTO_GENERATED_PRINT_VAR_START__
    print([==[M.format ft:]==], vim.inspect(ft)) -- __AUTO_GENERATED_PRINT_VAR_END__
    vim.lsp.buf.format {
      async = false,
      filter = function(client)
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[M.format#if#function client:]==], vim.inspect(client.name)) -- __AUTO_GENERATED_PRINT_VAR_END__
        if vim.tbl_contains({ 'eslint' }, client.name) then
          return true
        end
        return false
      end,
      bufnr = bufnr,
    }
  else
    require('conform').format {
      async = false,
      buf = bufnr,
    }
  end
end

function M.get_cmp_capabilities(flags)
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  flags = flags or {}
  local res = require('cmp_nvim_lsp').default_capabilities()
  res.textDocument.completion.completionItem.snippetSupport = true
  res.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  if vim.tbl_contains(flags, 'format') then
    res.documentFormattingProvider = true
  end
  return res
end

M.flags = {
  -- debounce_text_changes = 200,
  -- allow_incremental_sync = true,
}

function M.start()
  local ft = vim.api.nvim_buf_get_option(0, 'filetype')
  if vim.tbl_contains({ 'markdown', 'tex', 'gitcommit', 'text' }, ft) then
    require 'ltex_extra'
  elseif vim.tbl_contains({ 'lua' }, ft) then
    require 'neodev'
  end
  vim.cmd 'LspStart'
end

function M.start_client(name)
  error 'TODO'
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
