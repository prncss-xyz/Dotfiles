local M = {}

function M.config()
  local ls = require 'luasnip'
  ls.config.set_config { history = false, enable_autosnippets = false }

  if false then
    require('luasnip.loaders.from_vscode').lazy_load '' -- to load snippets in plugin path
  end

  require('luasnip.loaders.from_vscode').lazy_load {
    paths = require 'parameters'.vim_conf .. '/snippets/textmate',
  }
  require('luasnip.loaders.from_lua').lazy_load {
    paths = require 'parameters'.vim_conf .. '/snippets/luasnip',
  }
end

local U = {}

M.utils = U

return M
