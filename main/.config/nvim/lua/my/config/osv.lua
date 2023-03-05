local M = {}

function M.launch()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    -- require('osv').run_this()
    require('osv').launch {
      type = 'server',
      host = '127.0.0.1',
      port = 30000,
    }
  end
end

return M
