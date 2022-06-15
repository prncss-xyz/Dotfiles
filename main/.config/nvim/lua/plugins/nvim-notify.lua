local M = {}

local extract_nvim_hl = require('util').extract_nvim_hl

function M.config()
  vim.notify = require 'notify'
  require('notify').setup {
    -- https://github.com/rcarriga/nvim-notify/issues/99
    stage = 'fade',
    max_height = 20,
    on_open = function(win)
      vim.api.nvim_win_set_option(win, 'wrap', true)
    end,
  }
end

return M
