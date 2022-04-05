local cmp = require 'cmp'

local sources = {
  { name = 'luasnip' },
  { name = 'nvim_lua' },
  { name = 'nvim_lsp' },
  { name = 'path' },
  { name = 'buffer' },
  { name = 'spell' },
  { name = 'neorg' },
}

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
    format = function(entry, vim_item)
      vim_item.kind = symbolic(vim_item.kind)
      vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
      return vim_item
    end,
  },
  sources = sources,
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
