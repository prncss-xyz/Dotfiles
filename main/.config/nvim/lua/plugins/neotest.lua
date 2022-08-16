local M = {}

function M.config()
  require('neotest').setup {
    icons = {
      running = '勒',
    },
    adapters = {
      require 'neotest-plenary',
      require 'neotest-jest' {},
    },

    -- causes overseer run popup to appear when lauching jest debug
    -- works fine when calling neotest directly

    -- consumers = {
    --   overseer = require 'neotest.consumers.overseer',
    -- },
    -- overseer = {
    --   enabled = true,
    --   -- When this is true (the default), it will replace all neotest.run.* commands
    --   force_default = false,
    -- },
  }
end

return M
