return {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      'crispgm/telescope-heading.nvim',
      config = function()
        require("telescope").load_extension("heading")
      end,
    },
    {
      dir = require "my.utils".local_repo "telescope-repo.nvim",
      config = function()
        require("telescope").load_extension("repo")
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      config = require('my.config.telescope').config,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
        'crispgm/telescope-heading.nvim',
        dir = require "my.utils".local_repo "telescope-repo.nvim",
      },
    },
  }
