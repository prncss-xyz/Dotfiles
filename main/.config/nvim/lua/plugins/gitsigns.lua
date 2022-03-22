local M = {}

function M.setup()
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
  }
end

return M
