local M = {}

function M.config()
  require('yanky').setup {
    ring = {
      sync_with_numbered_registers = true,
    },
    highlight = {
      timer = 200,
    },
    system_clipboard = { sync_with_ring = true },
  }
end

return M
