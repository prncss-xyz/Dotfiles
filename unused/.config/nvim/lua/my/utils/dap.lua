local M = {}

function M.launch()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    if true then
      require('osv').run_this {
        log = vim.fn.stdpath 'data' .. '/osv.log',
      }
    else
      require('osv').launch {
        port = 8086,
        log = vim.fn.stdpath 'data' .. '/osv.log',
      }
    end
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
