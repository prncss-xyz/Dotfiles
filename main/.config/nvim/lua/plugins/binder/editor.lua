local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.utils'
  local lazy_req = util.lazy_req
  local repeatable = util.repeatable

  return keys {
    redup = keys {
      prev = b { require('utils.windows').show_ui_last, desc = 'last ui' },
      next = b { require('utils.windows').show_ui, desc = 'close ui' },
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
        require('utils.windows').winpick_swap,
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
          require('utils.windows').winpick_clone_to,
        },
        next = b {
          desc = 'clone from',
          require('utils.windows').winpick_clone_from,
        },
      },
      x = b {
        desc = 'close',
        require('utils.windows').winpick_close,
      },
      w = b {
        desc = 'external',
        require('utils.windows').split_external,
      },
      z = keys {
        prev = b {
          desc = 'zen',
          'ZenMode',
          cmd = true,
        },
        next = b { require('utils.windows').zoom },
      },
      [';'] = b {
        util.lazy(require('utils.windows').split_right, 85),
        desc = 'vertical 85',
      },
    },
    d = b { desc = 'filetype docu', require('utils').docu_current },
    e = keys {
      prev = b { desc = 'reset editor', require('utils').reset_editor },
      next = b {
        desc = 'current in new editor',
        require('utils').edit_current,
      },
    },
    f = keys {
      prev = b {
        lazy_req('utils.windows', 'show_ui', 'neo-tree', 'Neotree git_status'),
        desc = 'neo-tree git',
      },
      next = b {
        lazy_req('utils.windows', 'show_ui', 'neo-tree', 'Neotree'),
        desc = 'neo-tree',
      },
    },
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
    m = b {
      desc = 'toggle foldsigns',
      function()
        if vim.wo.foldcolumn == '1' then
          vim.wo.foldcolumn = '0'
        else
          vim.wo.foldcolumn = '1'
        end
      end,
    },
    o = b {
      desc = 'open current external',
      require('utils').open_current,
    },
    i = keys {
      prev = b {
        desc = 'setup-session launch',
        lazy_req('setup-session', 'launch'),
      },
      next = b {
        desc = 'setup-session develop',
        lazy_req('setup-session', 'develop'),
      },
    },
    t = b { desc = 'new terminal', require('utils').term },
    u = b {
      desc = 'undo tree',
      lazy_req(
        'utils.windows',
        'show_ui',
        { 'undotree', 'diff' },
        'UndotreeToggle'
      ),
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
    x = b { desc = 'xplr', require('utils').xplr_launch },
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
