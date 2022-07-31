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
    consumers = {
      overseer = require 'neotest.consumers.overseer',
    },
    overseer = {
      enabled = true,
      -- When this is true (the default), it will replace all neotest.run.* commands
      force_default = true,
    },
  }
end

return M
