return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = false,
        globalstatus = true,
      },
      sections = {
        lualine_a = { require 'my.utils.uiline.file' },
        lualine_b = { require 'my.utils.uiline.aerial' },
        lualine_c = {},
        lualine_x = { require 'my.utils.uiline.overseer' },
        -- lualine_x = { 'overseer' },
        lualine_y = { require 'my.utils.uiline.coordinates' },
        lualine_z = {},
      },
    },
    dependencies = 'MunifTanjim/nui.nvim',
  },
  {
    'kyazdani42/nvim-web-devicons',
    opts = { default = true },
  },
  {
    's1n7ax/nvim-window-picker',
    config = function()
      require('window-picker').setup {
        selection_chars = require('my.config.binder.parameters').selection_chars:upper(),
      }
    end,
  },
  -- git
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      watch_gitdir = {
        interval = 100,
      },
      sign_priority = 5,
      status_formatter = nil, -- Use default
      signs = {
        add = { hl = 'DiffAdd', text = '▌', numhl = 'GitSignsAddNr' },
        change = { hl = 'DiffChange', text = '▌', numhl = 'GitSignsChangeNr' },
        delete = { hl = 'DiffDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
        topdelete = {
          hl = 'DiffDelete',
          text = '‾',
          numhl = 'GitSignsDeleteNr',
        },
        changedelete = {
          hl = 'DiffChange',
          text = '~',
          numhl = 'GitSignsChangeNr',
        },
      },
      numhl = false,
      keymaps = {},
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      word_diff = false,
    },
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
    opts = {
      show_current_context = false,
      char = ' ',
      buftype_exclude = { 'terminal', 'help', 'nofile' },
      filetype_exclude = { 'help', 'packer' },
      char_highlight_list = { 'CursorLine', 'Function' },
      space_char_highlight_list = { 'CursorLine', 'Function' },
      space_char_blankline_highlight_list = { 'CursorLine', 'Function' },
    },
  },
  {
    'lukas-reineke/headlines.nvim',
    opts = {},
    ft = { 'markdown', 'orgmode', 'neorg' },
    enabled = false,
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
    opts = {
      input = {
        prefer_width = 70,
      },
    },
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
    'Vigemus/iron.nvim',
    cmd = {
      'IronRepl',
      'IronRestart',
      'IronFocus',
      'IronHide',
    },
    config = function()
      -- not serializalbe
      require('iron.core').setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { 'zsh' },
            },
            lua = {
              command = { 'lua' },
            },
            javascript = {
              command = { 'node' },
            },
            javascriptreact = {
              command = { 'node' },
            },
            typescript = {
              command = { 'node' },
            },
            typescriptreact = {
              command = { 'node' },
            },
            go = {
              command = { 'yaegi' },
            },
            haskell = {
              command = function(meta)
                local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
                return require('haskell-tools').repl.mk_repl_cmd(file)
              end,
            },
          },
          repl_open_cmd = require('iron.view').right(100),
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      }
    end,
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
