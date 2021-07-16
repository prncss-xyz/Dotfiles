local M = {}

function M.setup()
  -- emoji:🕯️🪛🔨
  -- nerdfonts: 
  vim.fn.sign_define(
    'LightBulbSign',
    { text = '', texthl = '', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapBreakpoint',
    { text = '🛑', texthl = '', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapStopped',
    { text = '🟢', texthl = '', linehl = '', numhl = '' }
  )
  -- vim.fn.sign_define('DapLogPoint', {text='→', texthl='', linehl='', numhl=''})
  -- vim.fn.sign_define('DapBreakpointRejected', {text='R', texthl='', linehl='', numhl=''})
end

-- I think signs are added per buffer, hence cannot be set by a plain sign_define command
M.plugins = {
  gitsigns = {
    signs = {
      add = { hl = 'DiffAdd', text = '▌', numhl = 'GitSignsAddNr' },
      change = { hl = 'DiffChange', text = '▌', numhl = 'GitSignsChangeNr' },
      delete = { hl = 'DiffDelete', text = '_', numhl = 'GitSignsDeleteNr' },
      topdelete = { hl = 'DiffDelete', text = '‾', numhl = 'GitSignsDeleteNr' },
      changedelete = { hl = 'DiffChange', text = '~', numhl = 'GitSignsChangeNr' },
    },
    numhl = false,
  },
}

return M

-- list all defined signs: `:sign list`
