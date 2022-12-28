local M = {}

function M.setup()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.utils'
  local lazy_req = util.lazy_req
  binder.bind(modes {
    t = keys {
      ['<c-w>n'] = b {
        '<C-\\><C-n>',
      },
    },
    c = keys {
      ['<m-e>'] = b { '<c-f>' },
      ['<tab>'] = b { require('plugins.binder.actions').menu_next },
      ['<s-tab>'] = b { require('plugins.binder.actions').menu_previous },
    },
    is = keys {
      ['<c-n>'] = b { require('plugins.binder.actions').menu_next },
      ['<c-p>'] = b { require('plugins.binder.actions').menu_previous },
      ['<c-space>'] = b { '<space><left>' },
      ['<c-z>'] = b { lazy_req('plugins.cmp', 'utils.toggle') },
      ['<s-tab>'] = b {
        require('plugins.binder.actions').jump_previous,
        desc = 'prev insert point',
      },
      ['<tab>'] = b {
        require('plugins.binder.actions').jump_next,
        desc = 'next insert point',
      },
      ['<c-v>'] = b { '<c-r><c-o>+' },
      -- ['<c-v>'] = b { '<c-r>+' },
      ['<c-r>'] = b {
        '<c-r>"',
      },
    },
    isc = keys {
      ['<c-a>'] = b { lazy_req('readline', 'beginning_of_line') },
      ['<c-f>'] = b { lazy_req('plugins.cmp', 'utils.confirm') },
      ['<c-e>'] = b { lazy_req('readline', 'end_of_line') },
      ['<m-f>'] = b { lazy_req('readline', 'forward_word') },
      ['<c-k>'] = b { lazy_req('readline', 'kill_line') },
      ['<c-u>'] = b { lazy_req('readline', 'backward_kill_line') },
      ['<c-w>'] = b { lazy_req('readline', 'backward_kill_word') },
      ['<m-b>'] = b { lazy_req('readline', 'backward_word') },
      ['<m-d>'] = b { lazy_req('readline', 'kill_word') },
    },
    ni = keys {
      ['<c-s>'] = b {
        function()
          vim.cmd 'stopinsert'
          vim.lsp.buf.format(false)
        end,
      },
      desc = 'format',
    },
    -- iv = keys {
    --   ['<c-f>'] = b {
    --     function()
    --       require('luasnip.extras.otf').on_the_fly 'f'
    --     end,
    --     modes = 'vi',
    --   },
    -- },
  })

  -- prevent s-mode text to overwrite clipboard
  -- Add a map for every printable character to copy to black hole register
  local t = require('plugins.binder.utils').t
  for char_nr = 33, 126 do
    local char = vim.fn.nr2char(char_nr)
    vim.api.nvim_set_keymap(
      's',
      char,
      '<c-o>"_c' .. t(char),
      { noremap = true, silent = true }
    )
  end
  vim.api.nvim_set_keymap(
    's',
    '<bs>',
    '<c-o>"_c',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    's',
    '<space>',
    '<c-o>"_c<space>',
    { noremap = true, silent = true }
  )
  return t
end

return M
