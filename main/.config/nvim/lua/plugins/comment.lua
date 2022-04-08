local M = {}

local function pre_hook(ctx)
  local U = require 'Comment.utils'

  local location = nil
  if ctx.ctype == U.ctype.block then
    location = require('ts_context_commentstring.utils').get_cursor_location()
  elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
    location =
      require('ts_context_commentstring.utils').get_visual_start_location()
  end

  return require('ts_context_commentstring.internal').calculate_commentstring {
    key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
    location = location,
  }
end

function M.config()
  local ft = require 'Comment.ft'
  -- ft.set('fish', '#%s')
  require('Comment').setup {
    pre_hook = pre_hook,
    opleader = {
      block = '<plug>(u-comment-opleader-block)',
      line = '<plug>(u-comment-opleader-line)',
    },
    toggler = {
      block = '<plug>(u-comment-toggler-block)',
      line = '<plug>(u-comment-toggler-line)',
    },
  }

  vim.api.nvim_del_keymap('n', 'gcA' )
  vim.api.nvim_del_keymap('n', 'gcO' )
  vim.api.nvim_del_keymap('n', 'gco' )
end

return M
