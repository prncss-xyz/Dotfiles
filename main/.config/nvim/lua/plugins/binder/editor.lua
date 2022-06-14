local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.util'
  local lazy_req = util.lazy_req
  local repeatable = util.repeatable

  return keys {
    redup = keys {
      desc = 'toggle',
      prev = b { desc = 'back', require('modules.toggler').back },
      next = b { require('modules.toggler').toggle },
    },
    b = keys {
      desc = 'runner',
      redup = b {
        desc = 'dash run',
        ':DashRun<cr>',
      },
      y = b {
        desc = 'dash connect<cr>',
        ':DashConnect<cr>',
      },
      m = b {
        desc = 'carrot eval',
        ':CarrotEval<cr>',
      },
      n = b {
        desc = 'carrot new block',
        ':CarrotNewBlock<cr>',
      },
      s = b {
        desc = 'dash step',
        repeatable { lazy_req('dash', 'step') },
      },
      v = modes {
        desc = 'dash inspect',
        n = b { lazy_req('dash', 'inspect') },
        v = b { lazy_req('dash', 'vinspect') },
      },
      c = b {
        desc = 'dash continue',
        repeatable { lazy_req('dash', 'continue') },
      },
      p = b {
        desc = 'dash toggle breakpoit',
        lazy_req('dash', 'toggle_breakpoint'),
      },
    },
    c = keys {
      desc = 'windows',
      -- TODO: zoom
      prev = b { lazy_req('split', 'close'), desc = 'close' },
      -- q = b { desc = 'lsp', lazy_req('split', 'open_lsp'), modes = 'nx' },
      -- r = modes {
      --   desc = 'pop',
      --   n = b { lazy_req('split', 'pop', { target = 'here' }, 'n') },
      --   x = b { lazy_req('split', 'pop', { target = 'here' }, 'x') },
      -- },
      e = b {
        desc = 'swap',
        require('util.actions').winpick_swap,
      },
      h = b {
        desc = 'horizontal split equal',
        ':sp<cr>',
      },
      j = modes {
        desc = 'open',
        n = b { lazy_req('split', 'open', {}, 'n') },
        x = b { lazy_req('split', 'open', {}, 'x') },
      },
      n = keys {
        prev = b {
          desc = 'clone to',
          require('util.actions').winpick_clone_to,
        },
        next = b {
          desc = 'clone from',
          require('util.actions').winpick_clone_from,
        },
      },
      x = b {
        desc = 'close',
        require('util.actions').winpick_close,
      },
      z = keys {
        prev = b {
          desc = 'zen',
          require('modules.toggler').cb('ZenMode', 'ZenMode'),
        },
        next = b { require('plugins.binder.actions').zoom },
      },
      [';'] = b {
        util.lazy(require('util.actions').split_right, 85),
        desc = 'vertical 85',
      },
    },
    d = b { desc = 'filetype docu', require('bindutils').docu_current },
    e = keys {
      prev = b { desc = 'reset editor', require('bindutils').reset_editor },
      next = b {
        desc = 'current in new editor',
        require('bindutils').edit_current,
      },
    },
    f = keys {
      desc = 'neo tree',
      prev = b {
        'Neotree git_status',
        cmd = true,
      },
      next = b {
        'Neotree',
        cmd = true,
      },
    },
    -- f = b {
    --   desc = 'nvim tree',
    --   require('modules.toggler').cb('NvimTreeOpen', 'NvimTreeClose'),
    -- },
    h = keys {
      desc = 'help',
      redup = b {
        desc = 'tags',
        lazy_req('telescope.builtin', 'help_tags'),
      },
      c = b {
        desc = 'highlights',
        lazy_req('telescope.builtin', 'highlights'),
      },
      d = b {
        desc = 'markdown files',
        lazy_req('telescope', 'extensions.my.md_help'),
      },
      m = b {
        desc = 'man pages',
        lazy_req('telescope.builtin', 'man_pages'),
      },
      o = b {
        -- FIXME:
        desc = 'modules',
        lazy_req('telescope', 'extensions.my.modules'),
      },
      y = b {
        desc = 'uniduck',
        lazy_req('telescope', 'extensions.my.uniduck'),
      },
    },
    k = keys {
      prev = b { desc = 'signature help', vim.lsp.buf.signature_help },
      next = b { desc = 'hover', vim.lsp.buf.hover },
    },
    o = b {
      desc = 'open current external',
      require('bindutils').open_current,
    },
    p = b {
      desc = 'session develop',
      require('modules.setup-session').develop,
    },
    -- t = b { desc = 'new terminal', require('bindutils').term },
    u = b {
      desc = 'undo tree',
      require('modules.toggler').cb('UndotreeToggle', 'UndotreeToggle'),
    },
    v = keys {
      prev = b {
        desc = 'projects (directory)',
        lazy_req('telescope', 'extensions.my.project_directory'),
      },
      next = b {
        desc = 'projects',
        lazy_req('telescope', 'extensions.my.projects'),
      },
    },
    x = b { desc = 'xplr', require('bindutils').xplr_launch },
    y = keys {
      desc = 'neoclip',
      q = b {
        desc = 'marco',
        lazy_req('telescope', 'extensions.macroscope.default'),
      },
      r = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.+') },
      f = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.f') },
      y = b {
        desc = 'yank',
        lazy_req('telescope', 'extensions.neoclip.default'),
      },
    },
    ['<space>'] = b { ':', modes = 'nx' },
  }
end

return M
