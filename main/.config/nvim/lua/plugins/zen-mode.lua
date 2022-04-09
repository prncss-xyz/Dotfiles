local M = {}

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
      gitsigns = { enabled = false },
      twilight = { enabled = true },
    },
    on_open = function()
      local Job = require 'plenary'.job
      Job
        :new({ command = 'wtype', args = { '-M', 'ctrl', '--', '+++++' } })
        :sync()
      Job:new({ command = 'swaymsg', args = { 'fullscreen', 'enable' } }):sync()
    end,
    on_close = function()
      local Job = require 'plenary'.job
      Job
        :new({ command = 'wtype', args = { '-M', 'ctrl', '--', '-----' } })
        :sync()
      Job:new({ command = 'swaymsg', args = { 'fullscreen', 'disable' } }):sync()
    end,
  }
end

return M
