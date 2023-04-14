local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('my.config.binder.utils').lazy_req

  return keys {
    a = keys {
      desc = 'dial',
      -- b { '<Plug>(dial-increment-additional)', modes = 'x' },
      -- b { '<Plug>(dial-decrement-additional)', modes = 'x' },
      -- prev = modes {
      --   n = b { '<Plug>(dial-decrement)' },
      --   x = b { require('my.config.dial').my.utils.decrement_x },
      -- },
      -- next = modes {
      --   n = b { '<Plug>(dial-increment)' },
      --   x = b { require('my.config.dial').my.utils.increment_x },
      -- },
      prev = modes {
        n = b {
          function()
            require('flies.operations.descend'):exec()
          end,
        },
      },
      next = modes {
        n = b {
          function()
            require('flies.operations.ascend'):exec()
          end,
        },
      },
    },
    b = b { 'gi', 'last insert point' },
    c = modes {
      n = b {
        'req',
        'flies.operations.act',
        'exec',
        {
          around = 'always',
        },
        nil,
        'c',
      },
      x = b { 'c' },
    },
    d = modes {
      n = b {
        function()
          require('flies.operations.act').exec({
            domain = 'outer',
            around = 'always',
          }, nil, 'd')
        end,
      },
      x = b { 'd' },
    },
    --[[
    o = function()
      require('Comment.api').locked.insert_linewise_below()
    end,
    po = function()
      require('Comment.api').locked.insert_linewise_above()
    end,
    pp = function()
      require('Comment.api').locked.insert_linewise_eol()
    end,
    ]]
    e = b {
      desc = 'swap',
      function()
        require('flies.operations.swap').exec 'n'
      end,
      modes = 'nx',
    },
    f = keys {
      desc = 'debug print',
      prev = b {
        desc = 'cleanup',
        function()
          require('refactoring').debug.cleanup {}
        end,
      },
      next = modes {
        n = b {
          function()
            require('refactoring').debug.print_var { normal = true }
          end,
        },
        x = b {
          function()
            require('refactoring').debug.print_var {}
          end,
        },
      },
    },
    g = b {
      desc = 'treesj',
      '<cmd>TSJToggle<cr>',
    },
    i = b {
      'i<space><left>',
    },
    j = modes {
      --FIX: currently not working
      desc = 'refactoring',
      x = b {
        function()
          require('telescope').extensions.refactoring.refactors()
        end,
      },
    },
    k = keys {
      prev = modes {
        n = b {
          function()
            require('flies.operations.act').exec(
              { domain = 'inner', around = 'never' },
              nil,
              '<plug>(comment_toggle_blockwise)'
            )
          end,
          noremap = false,
        },
        x = b { '<plug>(comment_toggle_blockwise_visual)' },
      },
      next = modes {
        n = b {
          function()
            require('flies.operations.act').exec(
              { domain = 'outer', around = 'never' },
              nil,
              '<plug>(comment_toggle_linewise)'
            )
          end,
          noremap = false,
        },
        x = b { '<plug>(comment_toggle_linewise_visual)' },
      },
    },
    l = b {
      desc = 'longnose',
      lazy_req('longnose', 'exec', 'replace'),
    },
    m = b { 'J', 'join', modes = 'nx' },
    n = keys {
      desc = 'annotate',
      n = b {
        function()
          require('neogen').generate {}
        end,
        desc = 'all',
        -- 'annotate (neogen)',
      },
      c = b {
        function()
          require('neogen').generate { type = 'class' }
        end,
        desc = 'class',
      },
      f = b {
        function()
          require('neogen').generate { type = 'func' }
        end,
        desc = 'function',
      },
      t = b {
        function()
          require('neogen').generate { type = 'type' }
        end,
        desc = 'type',
      },
    },
    o = keys {
      prev = b { 'O' },
      next = b { 'o' },
    },
    r = keys {
      prev = b { 'R' },
      next = b { 'r' },
    },
    -- s = b {
    --   desc = 'lsp rename',
    --   function()
    --     return ':IncRename ' .. vim.fn.expand '<cword>'
    --   end,
    --   expr = true
    -- },
    s = b { vim.lsp.buf.rename, 'rename' },
    t = b {
      desc = 'reindent',
      '=',
      modes = 'nx',
    },
    u = keys {
      -- [p(p 'u')] = {
      --   rep [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']],
      --   'change case',
      --   modes = 'nx',
      -- }, -- FIXME: not repeatable
      prev = b { 'gU', desc = 'uppercase', modes = 'nx' },
      next = b { 'gu', desc = 'lowercase', modes = 'nx' },
    },
    v = modes {
      n = keys {
        prev = b { 'P' },
        next = b { 'p' },
      },
      ox = keys {
        prev = b {
          function()
            local rs = '"' .. vim.v.register
            require('my.config.binder.utils').keys('"_d' .. rs .. 'P')
          end,
        },
        next = b {
          function()
            local rs = '"' .. vim.v.register
            require('my.config.binder.utils').keys('"_d' .. rs .. 'P')
          end,
        },
      },
    },
    w = b {
      desc = 'open-close',
      function()
        require('flies.operations.open_close'):exec()
      end,
    },
    x = b {
      desc = 'explode',
      function()
        require('flies.operations.explode').exec 'n'
      end,
      modes = 'nx',
    },
    y = modes {
      desc = 'wrap',
      n = b {
        function()
          require('flies.operations.wrap').exec 'n'
        end,
      },
      x = b {
        function()
          require('flies.operations.wrap').exec 'x'
        end,
      },
    },
    z = modes {
      desc = 'substitute',
      n = b {
        function()
          require('flies.operations.substitute').exec 'n'
        end,
      },
      x = b {
        function()
          require('flies.operations.substitute').exec 'x'
        end,
      },
    },
    ['<tab>'] = modes {
      nx = keys {
        prev = b { '<<' },
        next = b { '>>' },
      },
    },
    ['<space>'] = modes {
      n = b { vim.lsp.buf.code_action },
      x = b { ":'<,'>lua vim.lsp.buf.code_action()<cr>" },
    },
    ['<cr>'] = keys {
      prev = b {
        function()
          require('my.utils.blank_line').blank_line(false)
        end,
      },
      next = b {
        function()
          require('my.utils.blank_line').blank_line(true)
        end,
      },
    },
  }
end

return M
