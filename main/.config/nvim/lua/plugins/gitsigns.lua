local M = {}

function M.config()
  require('gitsigns').setup {
    watch_gitdir = {
      interval = 100,
    },
    sign_priority = 5,
    status_formatter = nil, -- Use default
    signs = {
      add = { hl = 'DiffAdd', text = '▌', numhl = 'GitSignsAddNr' },
      change = { hl = 'DiffChange', text = '▌', numhl = 'GitSignsChangeNr' },
      delete = { hl = 'DiffDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
      topdelete = {
        hl = 'DiffDelete',
        text = '‾',
        numhl = 'GitSignsDeleteNr',
      },
      changedelete = {
        hl = 'DiffChange',
        text = '~',
        numhl = 'GitSignsChangeNr',
      },
    },
    numhl = false,
    keymaps = {},
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    word_diff = false,
  }
  vim.cmd 'highlight! GitSignsCurrentLineBlame guifg=#7e8294'
end

return M
