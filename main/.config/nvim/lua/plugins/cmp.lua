require 'plugins.luasnip'


local cmp = require 'cmp'
local lspkind = require 'lspkind'
local sources = {
  { name = 'luasnip' },
  -- { name = 'nvim_lsp' },
  { name = 'spell' }, -- not good with fuzzy matching
  { name = 'path' },
  { name = 'buffer' },
  { name = 'neorg' },
}
local lua_sources = {
  { name = 'luasnip' },
  { name = 'nvim_lua' },
  { name = 'spell' }, -- not good with fuzzy matching
  { name = 'path' },
  { name = 'buffer' },
  { name = 'neorg' },
}

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({with_text = false, maxwidth = 50}),
    -- format = function(entry, vim_item)
    --   vim_item.kind = lspkind.presets.default[vim_item.kind]
    --   return vim_item
    -- end,
  },
  sources = sources,
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
  },
}

require('utils').augroup('CmpNvimLua', {
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
