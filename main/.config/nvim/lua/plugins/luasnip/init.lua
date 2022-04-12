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

local U = {}

M.utils = U

function U.next_choice()
  if require('luasnip').choice_active() then
    require('luasnip').change_choice(1)
    return true
  end
end

function U.previous_choice()
  if require('luasnip').choice_active() then
    require('luasnip').change_choice(-1)
    return true
  end
end

return M
