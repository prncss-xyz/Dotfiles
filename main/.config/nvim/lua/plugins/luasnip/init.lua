local M = {}

function M.config()
  local ls = require 'luasnip'
  ls.config.set_config { history = true, enable_autosnippets = false }

  if false then
    require('luasnip.loaders.from_vscode').lazy_load '' -- to load snippets in plugin path
  end

  require('luasnip.loaders.from_vscode').lazy_load {
    paths = vim.g.vim_dir .. '/snippets/textmate',
  }
  require('luasnip.loaders.from_lua').lazy_load {
    paths = vim.g.vim_dir .. '/snippets/luasnip',
  }
end

local U = {}

M.utils = U

return M
