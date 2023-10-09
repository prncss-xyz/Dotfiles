local M = {}

function M.setup()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  binder.bind(modes {
    t = keys {
      ['<s-esc>'] = b {
        '<C-\\><C-n>',
      },
    },
    c = keys {
      ['<m-e>'] = b { '<c-f>' },
      ['<tab>'] = b { 'req', 'my.config.binder.actions', 'menu_next_c' },
      ['<s-tab>'] = b { 'req', 'my.config.binder.actions', 'menu_previous_c' },
    },
    is = keys {
      ['<c-n>'] = b { 'req', 'my.config.binder.actions', 'menu_next' },
      ['<c-p>'] = b { 'req', 'my.config.binder.actions', 'menu_previous' },
      ['<c-space>'] = b { '<space><left>' },
      ['<c-e>'] = b { 'req', 'my.utils.cmp', 'toggle' },
      ['<s-tab>'] = b {
        function()
          require('luasnip').jump(-1)
        end,
        desc = 'prev insert point',
      },
      ['<tab>'] = b {
        function()
          require('luasnip').jump(1)
        end,
        desc = 'next insert point',
      },
      ['<c-v>'] = b { '<c-r><c-o>+' },
      --FIX: not working in s mode
      ['<c-r>'] = b { '<c-r><c-o>"' },
    },
    isc = keys {
      ['<c-a>'] = b { 'req', 'readline', 'beginning_of_line' },
      ['<c-b>'] = b { 'req', 'my.utils.moves', 'bwd', true },
      ['<c-f>'] = b {
        function()
          require('my.utils.moves').fwd(true)
        end,
      },
      ['<c-g>'] = b { 'req', 'my.utils.cmp', 'confirm' },
      ['<c-e>'] = b { 'req', 'readline', 'end_of_line' },
      ['<m-f>'] = b { 'req', 'readline', 'forward_word' },
      ['<c-k>'] = b { 'req', 'readline', 'kill_line' },
      ['<c-u>'] = b { 'req', 'readline', 'backward_kill_line' },
      ['<c-w>'] = b { 'req', 'readline', 'backward_kill_word' },
      ['<m-b>'] = b { 'req', 'readline', 'backward_word' },
      ['<m-d>'] = b { 'req', 'readline', 'kill_word' },
    },
    nx = keys {
      ['<c-b>'] = b { 'req', 'my.utils.moves', 'bwd', false },
    },
    ni = keys {
      ['<c-s>'] = b {
        function()
          vim.cmd 'stopinsert'
          require('my.utils.lsp').format()
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
  local t = require('my.config.binder.utils').t
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
