local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.util'
  local lazy_req = util.lazy_req

  return keys {
    redup = keys {
      desc = 'toggle',
      prev = b { desc = 'back', require('modules.toggler').back },
      next = b { require('modules.toggler').toggle },
    },
    a = b {
      desc = 'Diffview',
      require('modules.toggler').cb('DiffviewFileHistory', 'DiffviewClose'),
    },
    c = keys {
      desc = 'split',
      -- TODO: zoom
      prev = b { lazy_req('split', 'close'), desc = 'close' },
      -- q = b { desc = 'lsp', lazy_req('split', 'open_lsp'), modes = 'nx' },
      -- r = modes {
      --   desc = 'pop',
      --   n = b { lazy_req('split', 'pop', { target = 'here' }, 'n') },
      --   x = b { lazy_req('split', 'pop', { target = 'here' }, 'x') },
      -- },
      o = modes {
        desc = 'open',
        n = b { lazy_req('split', 'open', {}, 'n') },
        x = b { lazy_req('split', 'open', {}, 'x') },
      },
      z = keys {
        prev = b {
          desc = 'zen',
          require('modules.toggler').cb('ZenMode', 'ZenMode'),
        },
        next = b { require('plugins.binder.actions').zoom },
      },
      [';'] = b {
        function()
          vim.cmd [[
            vsp
            wincmd h
            vertical resize 85
        ]]
        end,
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
    f = b {
      desc = 'nvim tree',
      require('modules.toggler').cb('NvimTreeOpen', 'NvimTreeClose'),
    },
    g = b { desc = 'Neogit', require('modules.toggler').cb('Neogit', ':q') },
    h = keys {
      redup = b {
        desc = 'help tags',
        lazy_req('telescope.builtin', 'help_tags'),
      },
      c = b {
        desc = 'highlights',
        lazy_req('telescope.builtin', 'highlights'),
      },
      d = b {
        desc = 'md_help',
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
      p = b {
        desc = 'installed plugins',
        lazy_req('telescope', 'extensions.my.installed_plugins'),
      },
      u = b {
        desc = 'uniduck',
        lazy_req('telescope', 'extensions.my.uniduck'),
      },
    },
    i = keys {
      desc = 'unimpaired directory',
      prev = b { '<Plug>(unimpaired-directory-previous)' },
      next = b { '<Plug>(unimpaired-directory-next)' },
    },
    k = keys {
      prev = b { desc = 'signature help', vim.lsp.buf.signature_help },
      next = b { desc = 'hover', vim.lsp.buf.hover },
    },
    m = b {
      desc = 'plugins',
      lazy_req('telescope', 'extensions.my.installed_plugins'),
    },
    n = b {
      desc = 'node modules',
      lazy_req('telescope', 'extensions.my.node_modules'),
    },
    o = b {
      desc = 'open current external',
      require('bindutils').open_current,
    },
    pp = b {
      desc = 'session develop',
      require('modules.setup-session').develop,
    },
    r = b { 'reload', '<cmd>update<cr><cmd>so %<cr>' },
    -- t = b { desc = 'new terminal', require('bindutils').term },
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
    y = b {
      desc = 'undo tree',
      require('modules.toggler').cb('UndotreeToggle', 'UndotreeToggle'),
    },
    ['<space>'] = b {
      desc = 'commands',
      lazy_req('telescope.builtin', 'commands'),
    },
  }
end

return M
