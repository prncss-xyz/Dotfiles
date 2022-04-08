local M = {}

function M.config()
  local cmp = require 'cmp'

  local symbolic = require('symbols').symbolic

  ---@diagnostic disable-next-line: redundant-parameter
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    dcumentation = {},
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = symbolic(vim_item.kind)
        vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
        return vim_item
      end,
    },
    sources = {
    { name = 'cmp_tabnine' }, -- not currently in use
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    },
    experimental = {
      ghost_text = false,
    },
  }

  cmp.setup.cmdline('/', {
    sources = {
    { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    sources = {
    { name = 'cmdline' },
    { name = 'path' },
    },
  })

  cmp.setup.markdown = {
    sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'spell' },
    }
  }
end

return M
