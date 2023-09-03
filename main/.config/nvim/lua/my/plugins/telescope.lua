return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function()
      require('telescope').load_extension 'fzf'
    end,
  },
  {
    'crispgm/telescope-heading.nvim',
    config = function()
      require('telescope').load_extension 'heading'
    end,
  },
  {
    'AckslD/nvim-neoclip.lua',
    config = function()
      require('telescope').load_extension 'neoclip'
      require('telescope').load_extension 'macroscope'
    end,
  },
  {
    dir = require('my.utils').local_repo 'telescope-repo.nvim',
    config = function()
      require('telescope').load_extension 'repo'
    end,
  },
  {

    dir = require('my.utils').local_repo 'telescope-repo.nvim',
  },
  {
    'nvim-telescope/telescope.nvim',
    config = require('my.config.telescope').config,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
  },
  {
    'wintermute-cell/gitignore.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    cmd = 'Gitignore',
  },
}
