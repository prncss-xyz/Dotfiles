require 'plugins.luasnip'

local cmp = require 'cmp'

local sources = {
  { name = 'luasnip' },
  -- { name = 'nvim_lsp' },
  { name = 'spell' },
  { name = 'path' },
  { name = 'buffer' },
  -- { name = 'fuzzy_path' },
  -- { name = 'fuzzy_buffer' },
  { name = 'neorg' },
}

local lua_sources = {
  { name = 'luasnip' },
  { name = 'nvim_lua' },
  { name = 'spell' },
  { name = 'path' },
  { name = 'buffer' },
  -- { name = 'fuzzy_path' },
  -- { name = 'fuzzy_buffer' },
  { name = 'neorg' },
}

local symbolic = require('symbols').symbolic

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
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
  },
}

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  },
})

require('cmp').setup.cmdline(':', {
  sources = {
    { name = 'cmdline' },
    { name = 'buffer' },
  },
})

if false then
require('modules.utils').augroup('CmpNvimLua', {
  {
    events = { 'FileType' },
    targets = { 'lua' },
    command = function()
      require('cmp').setup.buffer {
        sources = lua_sources,
      }
    end,
  },
})
end
