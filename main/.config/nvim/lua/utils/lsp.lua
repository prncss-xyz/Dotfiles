local M = {}

--- test is named client is active on current buffer
---@param name string: the lsp client: ex.: 'tsserver'
---@return boolean
function M.is_client_current(name)
  local clients = vim.lsp.get_active_clients()
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in ipairs(clients) do
    if name == client.config.name and client.attached_buffers[bufnr] then
      return true
    end
  end
  return false
end

return M
