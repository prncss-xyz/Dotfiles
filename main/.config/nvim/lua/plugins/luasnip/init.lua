local M = {}

function M.config()
  local ls = require 'luasnip'
  ls.config.set_config { history = false, enable_autosnippets = false }
  if true then
    ls.filetype_extend('javascriptreact', { 'javascript' })
    ls.filetype_extend('typescript', { 'javascript' })
    ls.filetype_extend(
      'typescriptreact',
      {
        'javascriptreact',
        -- 'typescript',
        'javascript',
      }
    )
  end

  require('luasnip.loaders.from_vscode').lazy_load {
    paths = { require('parameters').vim_conf .. '/snippets/textmate' },
  }

  require('luasnip.loaders.from_lua').lazy_load {
    paths = { require('parameters').vim_conf .. '/snippets/luasnip' },
  }
end

local U = {}

M.utils = U

return M
