local M = {}

function M.config()
  local ls = require 'luasnip'
  ls.config.set_config {
    history = false,
    enable_autosnippets = false,
    snip_env = require 'my.config.luasnip.snip_env',
  }
  if true then
    ls.filetype_extend('javascriptreact', { 'javascript' })
    ls.filetype_extend('typescript', { 'javascript' })
    ls.filetype_extend('typescriptreact', {
      'javascriptreact',
      -- 'typescript',
      'javascript',
    })
  end

  ----FIX: not working
  if false then
    require('luasnip.loaders.from_vscode').lazy_load {
      -- paths = { require('my.parameters').vim_conf .. '/textmate' },
    }
  end

  --FIX: hot reload not working
  require('luasnip.loaders.from_lua').lazy_load {
    -- paths = { require('my.parameters').vim_conf .. '/luasnippets' },
  }
end

return M
