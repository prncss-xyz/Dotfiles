local M = {}
function M.setup()
  require('zen-mode').setup {
    height = 0.9,
    width = 90,
    plugins = {
      options = {
        ruler = true,
        showcmd = true,
      },
      gitsigns = { enabled = true },
      twilight = { enable = true },
    },
    on_open = function()
      vim.cmd 'TSContextDisable'
      vim.cmd 'echo ""'
    end,
    on_close = function()
      vim.cmd 'TSContextEnable'
    end,
  }
end
return M
