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
      prev = modes {
        n = b {
          function()
            require('flies.ioperations.dial').descend:exec()
          end,
        },
      },
      next = modes {
        n = b {
          function()
            require('flies.ioperations.dial').ascend:exec()
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
          around = 'never',
        },
        {},
        'c',
      },
      x = b { 'c' },
    },
    d = modes {
      n = b {
        'req',
        'flies.operations.act',
        'exec',
        {
          domain = 'outer',
          around = 'always',
        },
        {},
        'd',
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
    k = keys {
      prev = modes {
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
      next = modes {
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
    -- q = modes {
    --   desc = 'refactoring',
    --   x = b {
    --     function()
    --       require('telescope').extensions.refactoring.refactors()
    --     end,
    --   },
    -- },
    q = b {
      desc = 'refactoring',
      function()
        require('refactoring').select_refactor()
      end,
      modes = 'nx',
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
    -- v = modes {
    --   n = keys {
    --     prev = b { 'P' },
    --     next = b { 'p' },
    --   },
    --   ox = keys {
    --     prev = b {
    --       function()
    --         local rs = '"' .. vim.v.register
    --         require('my.config.binder.utils').keys('"_d' .. rs .. 'P')
    --       end,
    --     },
    --     next = b {
    --       function()
    --         local rs = '"' .. vim.v.register
    --         require('my.config.binder.utils').keys('"_d' .. rs .. 'P')
    --       end,
    --     },
    --   },
    -- },
    v = keys {
      desc = 'paste',
      prev = b {
        'keys',
        '<Plug>(YankyPutBefore)',
        modes = 'nx',
      },
      next = b {
        'keys',
        '<Plug>(YankyPutAfter)',
        modes = 'nx',
      },
    },
    w = b {
      desc = 'open-close',
      function()
        require('flies.ioperations.toggle'):exec()
      end,
    },
    x = b {
      desc = 'explode',
      function()
        require('flies.operations.explode'):call()
      end,
      modes = 'nx',
    },
    y = b {
      desc = 'wrap',
      function()
        require('flies.operations.wrap'):call()
      end,
      modes = 'nx',
    },
    z = b {
      desc = 'substitute',
      function()
        require('flies.operations.substitute'):call()
      end,
    },
    ['.'] = b {
      desc = 'insert prefix',
      'i.<left>',
    },
    [','] = b {
      desc = 'insert argument',
      'i, <left><left>',
    },
    ['<tab>'] = modes {
      nx = keys {
        prev = b { '<<' },
        next = b { '>>' },
      },
    },
    ['<space>'] = modes {
      nx = b { vim.lsp.buf.code_action },
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
