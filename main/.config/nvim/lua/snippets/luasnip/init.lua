local ls = require 'luasnip'

ls.add_snippets('fish', require 'snippets.luasnip.fish')
ls.add_snippets('all', require 'snippets.luasnip.all')
ls.add_snippets('lua', require 'snippets.luasnip.lua')
ls.add_snippets('javascript', require'snippets.luasnip.javascript')
ls.add_snippets('json', require'snippets.luasnip.json')
ls.add_snippets('vim', require'snippets.luasnip.vim')
