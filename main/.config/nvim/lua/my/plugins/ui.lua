return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = require('my.config.lualine').config,
    dependencies = 'MunifTanjim/nui.nvim',
  },
  {
    'kyazdani42/nvim-web-devicons',
    opts = { default = true },
  },
  -- git
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = require('my.config.gitsigns').config,
  },
  {
    'kevinhwang91/nvim-hlslens',
    name = 'hlslens',
    opts = {
      calm_down = true,
    },
    event = 'VeryLazy',
  },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    opts = {
      disable_builtin_notifications = true,
      kind = 'split',
      integrations = {
        diffview = true,
      },
    },
    enabled = false,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPost',
    config = require('my.config.indent-blankline').config,
  },
  {
    'lukas-reineke/headlines.nvim',
    opts = {},
    ft = { 'markdown', 'orgmode', 'neorg' },
  },
  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
  },
  {
    dir = require('my.utils').local_repo 'buffstory.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'rafcamlet/tabline-framework.nvim',
    config = require('my.config.tabline-framework').config,
    event = 'VeryLazy',
  },
  {
    'stevearc/dressing.nvim',
    config = require('my.config.dressing').config,
    event = 'VeryLazy',
  },
  {
    'folke/trouble.nvim',
    config = require('my.config.trouble').config,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    config = require('my.config.todo-comments').config,
    cmd = {
      'TodoTrouble',
      'TodoTelescope',
    },
  },
  {
    'folke/zen-mode.nvim',
    cmd = { 'ZenMode' },
    config = require('my.config.zen-mode').config,
  },
  {
    'folke/noice.nvim',
    event = 'VimEnter',
    cmd = 'Noice',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    },
  },
  {
    'karb94/neoscroll.nvim',
    opts = {
      mappings = {},
    },
  },
  {
    -- FIXME:
    'edluffy/specs.nvim',
    opts = {},
    dependencies = { 'neoscroll.nvim' },
  },

  -- Runners
  {
    'michaelb/sniprun',
    build = 'bash ./install.sh',
    enabled = false,
    module = 'sniprun',
    conif = {
      selected_interpreters = {
        'Python3_jupyter',
      },
    },
  },
  {
    'jbyuki/dash.nvim',
    cmd = { 'DashRun', 'DashConnect', 'DashDebug' },
  },

  -- Folding
  {
    'kevinhwang91/nvim-ufo',
    config = require('my.config.nvim-ufo').config,
    event = 'VeryLazy',
    dependencies = {
      'kevinhwang91/promise-async',
    },
  },
}
