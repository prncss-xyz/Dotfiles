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
    t 'if ',
    i(1, 'true'),
    t ' then',
    t { '', '' },
    i(2),
    t { '', 'end', '' },
  }),
  s({ trig = 'z' }, {
    t 'while ',
    i(1, 'true'),
    t ' do',
    t { '', '' },
    i(2),
    t { '', 'end' },
  }),
  s({ trig = 'f' }, {
    t 'function ',
    i(1),
    t '(',
    i(2),
    t ')',
    t { '', '  ' },
    i(3, '-- bloc'),
    t { '', 'end', '' },
  }),
}
