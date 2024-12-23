return {
  -- completion
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'Exafunction/codeium.nvim',
      { 'L3MON4D3/LuaSnip', run = 'make install_jsregexp' },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      --[[ 'hrsh7th/cmp-nvim-lua', ]]
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/cmp-nvim-lsp-signature-help',
      'f3fora/cmp-spell',
      -- 'petertriho/cmp-git',
      -- 'Gelio/cmp-natdat/'
    },
    config = function()
      local cmp = require 'cmp'
      local symbolic = require('my.utils.symbols').symbolic
      ---@diagnostic disable-next-line: redundant-parameter
      cmp.setup {
        PreselectMode = 'None', --'None'|'Item'
        completion = {
          keyword_length = 2,
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(_, vim_item)
            vim_item.kind = symbolic(vim_item.kind)
            vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
            return vim_item
          end,
          sorting = {
            priority_weight = 10,
          },
        },
        sources = {
          { name = 'luasnip' },
          --[[ { name = 'nvim_lsp_signature_help' }, ]]
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'cmp_overseer' },
          { name = 'calc' },
          -- { name = 'npm', keyword_length = 4 },
          { name = 'path' },
          --[[ { name = 'codeium' }, ]]
          { name = 'buffer' },
          -- {
          --   name = 'spell',
          --   option = {
          --     keep_all_entries = false,
          --     enable_in_context = function()
          --       return true
          --       -- return require('cmp.config.context').in_treesitter_capture 'spell'
          --     end,
          --   },
          -- },
        },
      }
      for _, f in ipairs { 'gitcommit', 'NeogitCommitMessage' } do
        cmp.setup.filetype(f, {
          sources = {
            { name = 'cmp_git' },
            { name = 'cmp-conventionalcommits' },
            { name = 'path' },
            { name = 'buffer' },
          },
        })
      end

      for _, c in ipairs { '/', '?' } do
        cmp.setup.cmdline(c, {
          sources = {
            { name = 'cmdline_history' },
            { name = 'buffer' },
          },
        })
      end
      -- input commandline
      cmp.setup.cmdline('@', {
        sources = {
          { name = 'cmdline_history' },
          { name = 'buffer' },
        },
      })
      cmp.setup.cmdline(':', {
        sources = {
          { name = 'cmdline_history' },
          { name = 'cmdline' },
          { name = 'path' },
        },
      })
    end,
  },
  {
    'windwp/nvim-autopairs',
    opts = {
      disable_in_macro = true,
      -- check_ts = true,
      fast_wrap = {
        map = '<m-p>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        end_key = ';',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
      },
    },
    event = 'InsertEnter',
  },
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    opts = {},
    cmd = { 'Codeium' },
    enabled = false,
  },
  -- neocodeium
  {
    'Exafunction/codeium.vim',
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<C-y>', function()
        return vim.fn['codeium#Accept']()
      end, { expr = true })
      vim.keymap.set('i', '<c-;>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { expr = true })
      vim.keymap.set('i', '<c-,>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { expr = true })
      vim.keymap.set('i', '<c-x>', function()
        return vim.fn['codeium#Clear']()
      end, { expr = true })
    end,
    event = 'BufEnter',
    cmd = { 'Codeium' },
    enabled = false,
  },
  {
    'supermaven-inc/supermaven-nvim',
    opts = {
      keymaps = {
        accept_suggestion = '<c-l>',
        clear_suggestion = '<c-c>',
        accept_word = '<c-j>',
      },
      ignore_filetypes = { markdown = true },
    },
    cmd = { 'SupermavenUseFree', 'SupermavenLogout' },
    event = 'InsertEnter',
  },
  -- Use tressitter to autoclose and autorename HTML tag
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
    event = 'InsertEnter',
  },
  {
    -- annotation toolkit
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enabled = true,
      snippet_engine = 'luasnip',
    },
  },
}
