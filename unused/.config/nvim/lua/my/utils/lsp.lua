local M = {}

local block_list = { 'lua_ls', 'vtsls' }

function M.format(bufnr)
  --[[
  --
  require("conform").format({
    bufnr = bufnr,
    lsp_format = "fallback",
    async = true,
  })
  --]]
  vim.lsp.buf.format {
    async = false,
    filter = function(client)
      --[[ print(client.name, not vim.tbl_contains(block_list, client.name)) ]]
      return not vim.tbl_contains(block_list, client.name)
    end,
    bufnr = bufnr,
  }
end

function M.format_(bufnr)
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
    vim.lsp.buf.format {
      async = false,
      filter = function(client)
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
  --[[ local res = require('cmp_nvim_lsp').default_capabilities() ]]
  local res = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
    documentFormattingProvider = vim.tbl_contains(flags, 'format'),
  }
  res = require('blink.cmp').get_lsp_capabilities(res)
  return res
end

M.flags = {
  -- debounce_text_changes = 200,
  -- allow_incremental_sync = true,
}

function M.start()
  local ft = vim.api.nvim_get_option(0, 'filetype')
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
