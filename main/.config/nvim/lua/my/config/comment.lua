local M = {}

function M.config()
  local ft = require 'Comment.ft'
  ft.set('sway', '#%s')
  require('Comment').setup {
    mappings = {
      basic = false,
      extra = false,
    },
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  }
end

return M
