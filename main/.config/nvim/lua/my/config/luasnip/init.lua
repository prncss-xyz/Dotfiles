local M = {}

function M.config()
  local pair = require('my.utils.snippets.pair').pair
  local ls = require 'luasnip'
  ls.config.set_config {
    history = false,
    enable_autosnippets = false,
    -- snip_env = {
    --   u = require 'my.utils.snippets',
    --   pair = require 'my.utils.snippets.pair',
    -- },
  }
  if false then
    ls.filetype_extend('javascriptreact', { 'javascript' })
    ls.filetype_extend('typescript', { 'javascript' })
    ls.filetype_extend('typescriptreact', {
      'javascriptreact',
      -- 'typescript',
      'javascript',
    })
  end

  require('luasnip.loaders.from_vscode').lazy_load {
    paths = { require('my.parameters').vim_conf .. '/snippets/textmate' },
  }

  require('luasnip.loaders.from_lua').lazy_load {
    paths = { require('my.parameters').vim_conf .. '/snippets/luasnip' },
  }

  -- local s = ls.snippet
  local conds_expand = require 'luasnip.extras.conditions.expand'
  local s = ls.snippet
  local t = ls.text_node
  -- pair('all', '(', ')', 'same')
  --FIX: not working
  ls.add_snippets('all', {
    s('cond_bol', {
      t 'will only expand at the beginning of the line',
    }, {
      condition = conds_expand.line_begin,
    }),
  })
end

return M
