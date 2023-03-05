local M = {}

function M.config()
  local d = require('my.config.binder.parameters').d
  require('trouble').setup {
    position = 'left',
    width = require('my.parameters').pane_width,
    -- position = 'bottom',
    use_diagnostic_signs = true,
    action_keys = {
      close = {},
      refresh = 'r',
      jump = '<cr>',
      cancel = '<c-c>',
      open_split = '<c-x>',
      open_vsplit = '<c-v>',
      jump_close = 'o',
      toggle_fold = 'z',
      close_folds = {},
      hover = 'h',
      open_folds = {},
      next = d.down, -- next = d.down,
      previous = d.up,
      toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = 'l', -- toggle auto_preview
      preview = 'p', -- preview the diagnostic location
    },
  }
end

return M
