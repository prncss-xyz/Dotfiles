local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local isn = ls.indent_snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local p = require('luasnip.extras').partial

return {
  s({ trig = 'k' }, {
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
  }),
  s({ trig = 'y' }, {
    t 'if (',
    i(1, 'true'),
    t ') {',
    t { '', '' },
    i(2),
    t { '', '}', '' },
  }),
  s({ trig = 'z' }, {
    t 'while (',
    i(1, 'true'),
    t ') {',
    t { '', '' },
    i(2),
    t { '', '}' },
  }),
  s({ trig = 'f' }, {
    t 'function ',
    i(1, 'name'),
    t '(',
    i(2),
    t ') {',
    t { '', '  ' },
    i(3),
    t { '', '}', '' },
  }),
  s({
    trig = 'shebang',
  }, {
    t '#!/usr/bin/env node',
    f(function()
      vim.cmd 'Chmod +x'
      return ''
    end, {}),
    t { '', '' },
  }),
}
