local M = {}

function M.config()
  require('trouble').setup {
    position = 'left',
    width = vim.g.u_pane_width,
    -- position = 'bottom',
    use_diagnostic_signs = true,
    action_keys = require('bindings').plugins.trouble,
  }
end

return M
