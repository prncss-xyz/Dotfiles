return {
  {
    'stevearc/overseer.nvim',
    opts = {
      strategy = 'toggleterm',
    },
    config = function(_, opts)
      local overseer = require 'overseer'
      overseer.setup(opts)
    end,
    cmd = {
      'OverseerOpen',
      'OverseerClose',
      'OverseerToggle',
      'OverseerSaveBundle',
      'OverseerLoadBundle',
      'OverseerDeleteBundle',
      'OverseerRunCmd',
      'OverseerRun',
      'OverseerInfo',
      'OverseerBuild',
      'OverseerQuickAction',
      'OverseerTaskAction',
      'OverseerClearCache',
    },
  },
}
