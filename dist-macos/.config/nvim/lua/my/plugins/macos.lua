return {
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
      end,
      set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
      end,
    },
    config = function(_, opts)
      local auto_dark_mode = require 'auto-dark-mode'
      auto_dark_mode.setup(opts)
      auto_dark_mode.init()
    end,
    event = 'ColorSchemePre',
  },
}
