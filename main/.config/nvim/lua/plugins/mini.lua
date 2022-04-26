local M = {}

function M.setup()
  require('mini.surround').setup {
    mappings = {
      add = '<Plug>(u-surround-add)', -- Add surrounding
      delete = '', -- Delete surrounding
      find = '', -- Find surrounding (to the right)
      find_left = '', -- Find surrounding (to the left)
      highlight = '', -- Highlight surrounding
      replace = '', -- Replace surrounding
      update_n_lines = '', -- Update `n_lines`
    },
  }
end

return M
