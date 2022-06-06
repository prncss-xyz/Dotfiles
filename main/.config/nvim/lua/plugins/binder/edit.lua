local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req

  return keys {
    a = modes {
      -- n = cmd { 'CodeActionMenu', 'code action',
      n = b { vim.lsp.buf.code_action },
      x = b { ":'<,'>lua vim.lsp.buf.range_code_action()<cr>" },
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
          function()
            require('flies.actions').op(
              '<Plug>(comment_toggle_blockwise)',
              'outer',
              false
            )
          end,
          x = b { '<Plug>(comment_toggle_blockwise_visual)' },
        },
      },
      next = modes {
        n = b {
          function()
            require('flies.actions').op(
              '<Plug>(comment_toggle_linewise)',
              'outer',
              false
            )
          end,
        },
        x = b { '<Plug>(comment_toggle_linewise_visual)' },
      },
    },
    d = keys {
      -- b { '<Plug>(dial-increment-additional)', modes = 'x' },
      -- b { '<Plug>(dial-decrement-additional)', modes = 'x' },
      prev = modes {
        n = b { '<Plug>(dial-decrement)' },
        x = b { require('plugins.dial').utils.decrement_x },
      },
      next = modes {
        n = b { '<Plug>(dial-increment)' },
        x = b { require('plugins.dial').utils.increment_x },
      },
    },
    e = b { desc = 'swap', '<Plug>(flies-swap)', modes = 'nx' },
    -- x = keys {
    --   next = b {
    --     desc = 'exchange',
    --     '<Plug>(ExchangeClear)',
    --     modes = 'nx',
    --   },
    --   prev = b {
    --     desc = 'exchange',
    --     '<Plug>(Exchange)',
    --     modes = 'nx',
    --   },
    -- },
    g = keys {
      prev = b { '<cmd>SplitjoinJoin<cr>' },
      next = b { '<cmd>SplitjoinSplit<cr>' },
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
    s = b { vim.lsp.buf.rename, 'rename' },
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
            require('bindutils').keys('"_d' .. rs .. 'P')
          end,
        },
        next = b {
          function()
            local rs = '"' .. vim.v.register
            require('bindutils').keys('"_d' .. rs .. 'P')
          end,
        },
      },
    },
    x = b {
      desc = 'swipe',
      '<Plug>(flies-swipe)',
      modes = 'nx',
    },
    ['<tab>'] = keys {
      prev = modes {
        n = b {
          desc = 'dedent',
          '<<',
        },
      },
      next = modes {
        n = b {
          desc = 'indent',
          '>>',
        },
        x = b {
          desc = 'reindent',
          '=',
        },
      },
    },
    y = b {
      desc = 'sandwich add',
      n = b {
        function()
          require('flies.actions').op(
            '<Plug>(operator-sandwich-add)',
            'outer',
            false
          )
        end,
        x = b { '<Plug>(operator-sandwich-add)' },
      },
    },
    ['<cr>'] = keys {
      prev = b { '<Plug>(unimpaired-blank-up)' },
      next = b { '<Plug>(unimpaired-blank-down)' },
    },
  }
end

return M
