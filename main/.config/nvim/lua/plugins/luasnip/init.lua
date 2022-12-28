local M = {}

local pair = require('utils.snippets.pair').pair

function M.config()
  local ls = require 'luasnip'
  ls.config.set_config {
    history = false,
    enable_autosnippets = false,
    -- snip_env = {
    --   u = require 'utils.snippets',
    --   pair = require 'utils.snippets.pair',
    -- },
  }
  ls.filetype_extend('javascriptreact', { 'javascript' })
  ls.filetype_extend('typescript', { 'javascript' })
  ls.filetype_extend('typescriptreact', {
    'javascriptreact',
    -- 'typescript',
    'javascript',
  })

  require('luasnip.loaders.from_vscode').lazy_load {
    paths = { require('parameters').vim_conf .. '/snippets/textmate' },
  }

  require('luasnip.loaders.from_lua').lazy_load {
    paths = { require('parameters').vim_conf .. '/snippets/luasnip' },
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

local U = {}

M.utils = U

return M
