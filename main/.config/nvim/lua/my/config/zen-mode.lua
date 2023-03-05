local M = {}

local current_line_blame

function M.config()
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
      gitsigns = { enabled = true },
      twilight = { enabled = false },
    },
    on_open = function()
      -- FIXME: not working
      current_line_blame = require('gitsigns').toggle_current_line_blame(false)
      local Job = require('plenary').job
      Job
        :new({ command = 'wtype', args = { '-M', 'ctrl', '--', '+++++' } })
        :sync()
      Job:new({ command = 'swaymsg', args = { 'fullscreen', 'enable' } }):sync()
    end,
    on_close = function()
      require('gitsigns').toggle_current_line_blame(current_line_blame)
      local Job = require('plenary').job
      Job
        :new({ command = 'wtype', args = { '-M', 'ctrl', '--', '-----' } })
        :sync()
      Job:new({ command = 'swaymsg', args = { 'fullscreen', 'disable' } }):sync()
    end,
  }
end

return M
