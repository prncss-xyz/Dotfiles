return {
  -- completion
  {
    'David-Kunz/cmp-npm',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = 'json',
    opts = {},
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'Exafunction/codeium.nvim',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'f3fora/cmp-spell',
      -- 'petertriho/cmp-git',
    },
    config = function()
      local cmp = require 'cmp'
      local symbolic = require('my.utils.symbols').symbolic
      ---@diagnostic disable-next-line: redundant-parameter
      cmp.setup {
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
          { name = 'codeium' },
          { name = 'luasnip' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'cmp_overseer' },
          { name = 'calc' },
          -- { name = 'npm', keyword_length = 4 },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp' },
          { name = 'path' },
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
        map = '<m-e>',
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
    -- config = function()
    --   require('codeium').setup {}
    -- end,
    cmd = { 'Codeium' },
  },
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
    'codota/tabnine-nvim',
    build = './dl_binaries.sh',
    opts = {
      disable_auto_comment = false,
      -- accept_keymap = '<plug>(nop)',
      accept_keymap = '<c-y>',
      dismiss_keymap = '<plug>(nop)',
      -- dismiss_keymap = '<c-e>',
      debounce_ms = 800,
      suggestion_color = { gui = '#808080', cterm = 244 },
      exclude_filetypes = { 'TelescopePrompt', 'markdown' },
    },
    name = 'tabnine',
    config = true,
    cmd = {
      'TabnineHub',
      'TabnineHubUrl',
      'TabnineStatus',
      'TabnineDisable',
      'TabnineEnable',
      'TabnineToggle',
    },
    event = 'InsertEnter',
    enabled = false,
  },
}
