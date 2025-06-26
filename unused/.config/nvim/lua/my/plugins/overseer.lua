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
        'my.zsh',
        'my.zsh-current',
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
