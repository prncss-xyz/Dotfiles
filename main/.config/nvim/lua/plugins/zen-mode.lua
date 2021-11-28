local M = {}
function M.setup()
  require('zen-mode').setup {
    window = {
      height = 1,
      width = 81,
    },
    plugins = {
      options = {
        ruler = true,
        showcmd = false,
      },
      gitsigns = { enabled = false },
      twilight = { enable = true },
    },
  }
end
return M
