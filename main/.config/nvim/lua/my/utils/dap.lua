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
  elseif filetype == 'haskell' then
    require('haskell-tools').dap.discover_configurations(0)
  elseif filetype == 'go' then
    require('dap').run {
      type = 'go',
      request = 'launch',
    }
  else
    require('dap').run {
      type = 'pwa-node',
      request = 'launch',
    }
    -- require('dap').launch()
    -- log_error 'unsupported filetype'
  end
end

return M
