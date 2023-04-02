local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('my.config.binder.utils').lazy_req

  vim.keymap.set('n', '<plug>(substitute-operatior)', require('substitute').operator, { noremap = true })

  return keys {
    a = b {
      desc = 'reindent',
      '=',
      modes = 'nx',
    },
    b = b { 'gi', 'last insert point' },
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
    c = keys {
      prev = modes {
        n = b {
          '<plug>(comment_toggle_blockwise)<plug>(flies-select)',
          noremap = false,
        },
        x = b { '<plug>(comment_toggle_blockwise_visual)' },
      },
      next = modes {
        n = b {
          '<plug>(comment_toggle_linewise)<plug>(flies-select)',
          noremap = false,
        },
        x = b { '<plug>(comment_toggle_linewise_visual)' },
      },
    },
    d = keys {
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
            require('flies2.operations.descend'):exec()
          end,
        },
      },
      next = modes {
        n = b {
          function()
            require('flies2.operations.ascend'):exec()
          end,
        },
      },
    },
    e = b {
      desc = 'swap',
      function()
        require('flies2.operations.swap').exec 'n'
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
    q = keys {
      next = modes {
        desc = 'substitute',
        n = b {
          function()
            require('flies2.operations.act').exec(
              {},
              {},

   "v:lua.require'substitute'.operator_callback"
            )
          end,
        },
        x = b {
          function()
            require('substitute').visual()
          end,
        },
      },
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
    t = keys {
      desc = 'exchange',
      prev = b {
        desc = 'cancel',
        function()
          require('flies2.operations.act').exec(
            {},
            {},
            require('substitute').exchange
          )
        end,
      },
      next = modes {
        n = b {
          -- lazy_req('substitute', 'operator'),
          function()
            require('flies2.actions').op(
              "<cmd>lua require('substitute.exchange').operator()<cr>",
              -- lazy_req('substitute.exchange', 'operator'),
              { domain = 'inner' }
            )
          end,
        },
        x = b {
          lazy_req('substitute.exchange', 'visual'),
        },
      },
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
        require('flies2.operations.open_close'):exec()
      end,
    },
    x = b {
      desc = 'explode',
      function()
        require('flies2.operations.explode').exec 'n'
      end,
      modes = 'nx',
    },
    y = modes {
      desc = 'wrap',
      n = b {
        function()
          require('flies2.operations.wrap').exec 'n'
        end,
      },
      x = b {
        function()
          require('flies2.operations.wrap').exec 'x'
        end,
      },
    },
    z = modes {
      desc = 'substitute',
      n = b {
        function()
          require('flies2.operations.substitute').exec 'n'
        end,
      },
      x = b {
        function()
          require('flies2.operations.substitute').exec 'x'
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
      x = b { ":'<,'>lua vim.lsp.buf.range_code_action()<cr>" },
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
