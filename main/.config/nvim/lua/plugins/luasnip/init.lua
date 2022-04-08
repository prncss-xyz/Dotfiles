local M = {}

function M.config()
  local ls = require 'luasnip'
  ls.config.set_config { history = true, enable_autosnippets = false }

  -- require('luasnip/loaders/from_vscode').lazy_load('') -- to load snippets in plugin path
  require('luasnip.loaders.from_vscode').lazy_load {
    paths = './lua/snippets/textmate',
  }
  require 'snippets.luasnip'
end

return M
