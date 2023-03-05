local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local isn = ls.indent_snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local function first_word(s)
  local i = s:find(' ', 1, true)
  if i then
    return s:sub(1, i - 1)
  end
  return s
end

local function map(t, cb)
  local r = {}
  for k, v in pairs(t) do
    r[k] = cb(v)
  end
  return r
end

-- c: comment
-- k: call (ts)
-- p: paragraph (builtin)
-- y: conditional (ts)
-- z: loop (ts)

return {
  s({ trig = 'lua:k' }, {
    i(1, 'name'),
    t '(',
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t ')',
  }),
  s({ trig = 'javascript:k' }, {
    i(1, 'name'),
    t '(',
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t ')',
  }),
  s({ trig = 'lua:Y' }, {
    t 'if ',
    f(function()
      return require('modules.buffet').contents
    end, {}),
    i(1),
    t { ' then', '' },
    t '\t',
    i(2, '  -- block'),
    t { '', 'end', '' },
  }),
  s({ trig = 'javascript:Y' }, {
    t 'if (',
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t { ') {', '' },
    t '\t',
    i(2, '// block'),
    t { '', '}', '' },
  }),
  s({ trig = 'lua:y' }, {
    t 'if ',
    i(1, 'true'),
    t ' then',
    t { '', '' },
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t { '', 'end', '' },
  }),
  s({ trig = 'javascript:y' }, {
    t 'if (',
    i(1, 'true'),
    t ') {',
    t { '', '' },
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t { '', '}', '' },
  }),
  s({ trig = 'lua:Z' }, {
    t 'while ',
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t ' do',
    t { '', '' },
    t '\t',
    i(1, '-- block'),
    i(2),
    t { '', 'end' },
  }),
  s({ trig = 'javascript:Z' }, {
    t 'while (',
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t ') {',
    t { '', '  ' },
    t '\t',
    i(1, '// block'),
    i(2),
    t { '', '}' },
  }),
  s({ trig = 'lua:z' }, {
    t 'while ',
    i(1, 'true'),
    t ' do',
    t { '', '' },
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t { '', 'end' },
  }),
  s({ trig = 'javascript:z' }, {
    t 'while (',
    i(1, 'true'),
    t ') {',
    t { '', '' },
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t { '', '}' },
  }),
  s({ trig = 'lua:f' }, {
    t 'local function ',
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
    t { '', '  ' },
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t { '', 'end', '' },
  }),
  s({ trig = 'javascript:f' }, {
    t 'function ',
    i(1, 'name'),
    t '(',
    i(2),
    t ') {',
    t { '', '  ' },
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t { '', '}', '' },
  }),
  s({ trig = 'all:i' }, {
    i(1),
    f(function()
      return require('modules.buffet').contents
    end, {}),
  }),
  s({ trig = 'all:t' }, {
    t '<',
    i(1, 'tag'),
    t '>',
    f(function()
      return require('modules.buffet').contents
    end, {}),
    t '</',
    f(function(args)
      return first_word(args[1][1])
    end, { 1 }),
    t '>',
  }),
}
