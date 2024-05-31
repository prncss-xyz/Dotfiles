return {
  {
    'stevearc/overseer.nvim',
    opts = {
      strategy = {
        'toggleterm',
        open_on_start = true,
      },
      templates = {
        'builtin',
        --[[ 'my.dev', ]]
      },
    },
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
