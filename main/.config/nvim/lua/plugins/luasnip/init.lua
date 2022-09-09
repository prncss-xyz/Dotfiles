local M = {}

function M.config()
  local ls = require 'luasnip'
  ls.config.set_config { history = false, enable_autosnippets = false }
  ls.filetype_extend('javascriptreact', { 'javascript' })

  -- FIX: broke with a82d84a
  if false then
    require('luasnip.loaders.from_vscode').lazy_load {
      paths = { require('parameters').vim_conf .. '/snippets/textmate' },
    }
  end

  require('luasnip.loaders.from_lua').lazy_load {
    paths = { require('parameters').vim_conf .. '/snippets/luasnip' },
  }
end

local U = {}

M.utils = U

return M
