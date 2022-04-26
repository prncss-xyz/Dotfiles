local M = {}

function M.bind()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.util'
  local lazy_req = util.lazy_req

  binder.extend(
    'editor',
    keys {
      redup = keys {
        desc = 'toggle',
        prev = b { desc = 'back', require('modules.toggler').back },
        next = b { require('modules.toggler').toggle },
      },
      c = keys {
        desc = 'split',
        prev = b { lazy_req('split', 'close'), desc = 'close' },
        s = b { desc = 'lsp', lazy_req('split', 'open_lsp') },
        q = b { desc = 'caca', lazy_req('split', 'open_lsp'), modes = 'nx' },
        r = modes {
          desc = 'pop',
          n = b { lazy_req('split', 'pop', { target = 'here' }, 'n') },
          x = b { lazy_req('split', 'pop', { target = 'here' }, 'x') },
        },
        o = modes {
          desc = 'open',
          n = b { lazy_req('split', 'open', {}, 'n') },
          x = b { lazy_req('split', 'open', {}, 'x') },
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
      h = b {
        desc = 'Diffview',
        require('modules.toggler').cb('DiffviewFileHistory', 'DiffviewClose'),
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
      m = b { desc = 'plugins', 'Telescope installed_plugins', cmd = true },
      n = b { desc = 'node modules', 'Telescope modules', cmd = true },
      o = b {
        desc = 'open current external',
        require('bindutils').open_current,
      },
      pp = b {
        desc = 'session develop',
        require('modules.setup-session').develop,
      },
      r = b { 'reload', '<cmd>update<cr><cmd>so %<cr>' },
      t = b { desc = 'new terminal', require('bindutils').term },
      v = keys {
        prev = b {
          desc = 'projects',
          'Telescope project_directory',
          cmd = true,
        },
        next = b { desc = 'sessions', 'Telescope my_projects', cmd = true },
      },
      x = b { desc = 'xplr', require('bindutils').xplr_launch },
      y = b {
        desc = 'undo tree',
        require('modules.toggler').cb('UndotreeToggle', 'UndotreeToggle'),
      },
      z = b {
        desc = 'zen mode',
        require('modules.toggler').cb('ZenMode', 'ZenMode'),
      },
      ['<space>'] = b { desc = 'commands', 'Telescope commands', cmd = true },
    }
  )
end

return M
