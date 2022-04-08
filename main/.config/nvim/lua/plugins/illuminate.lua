local M = {}

function M.setup()
  vim.g.Illuminate_ftblacklist = { 'NeogitStatus' }
end

function M.config()
  local augroup = require('utils').augroup
  -- diminishes flashing while typing
  augroup('IlluminateInsert', {
    {
      events = { 'InsertEnter' },
      targets = { '*' },
      command = function()
        vim.g.Illuminate_delay = 1000
      end,
    },
  })

  augroup('IlluminateNormal', {
    {
      events = { 'InsertLeave' },
      targets = { '*' },
      command = function()
        vim.g.Illuminate_delay = 0
      end,
    },
  })
end

return M
