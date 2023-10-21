return {
  {
    'mrjones2014/legendary.nvim',
    opts = {
      include_builtin = false,
    },
    cmd = {
      'Legendary',
      'LegendaryScratch',
      'LegendaryEvalLine',
      'LegendaryEvalLines',
      'LegendaryEvalBuf',
      'LegendaryApi',
    },
  },
  {
    'linty-org/key-menu.nvim',
    enabled = false,
  },
  {
    dir = require('my.utils').local_repo 'binder.nvim',
    config = require('my.config.binder').config,
    event = 'VimEnter',
  },
}
