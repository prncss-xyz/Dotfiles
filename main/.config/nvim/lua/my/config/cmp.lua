local M = {}

function M.config()
  local cmp = require 'cmp'

  local symbolic = require('my.utils.symbols').symbolic

  ---@diagnostic disable-next-line: redundant-parameter
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    window = {
      documentation = true,
    },
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = symbolic(vim_item.kind)
        vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
        return vim_item
      end,
      sorting = {
        priority_weight = 10,
      },
    },
    experimental = {
      ghost_text = false,
    },
    sources = {
      { name = 'cmp_overseer' },
      { name = 'calc' },
      { name = 'luasnip' },
      { name = 'npm', keyword_length = 4 },
      { name = 'nvim_lua' },
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
    },
  }

  for _, f in ipairs { 'gitcommit', 'NeogitCommitMessage' } do
    cmp.setup.filetype(f, {
      sources = {
        { name = 'cmp_git' },
        { name = 'cmp-conventionalcommits' },
        { name = 'path' },
        { name = 'buffer' },
      },
    })
  end

  for _, c in ipairs { '/', '?' } do
    cmp.setup.cmdline(c, {
      sources = {
        { name = 'cmp-cmdline-history' },
        { name = 'buffer' },
      },
    })
  end
  -- input commandline
  cmp.setup.cmdline('@', {
    sources = {
      { name = 'cmp-cmdline-history' },
      { name = 'buffer' },
    },
  })
  cmp.setup.cmdline(':', {
    sources = {
      { name = 'cmp-cmdline-history' },
      { name = 'cmdline' },
      { name = 'path' },
    },
  })
end

return M
