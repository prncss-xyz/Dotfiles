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
  }
end
return M
