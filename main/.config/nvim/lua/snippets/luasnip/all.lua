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

local function first_word(s)
  local i = s:find(' ', 1, true)
  if i then
    return s:sub(1, i - 1)
  end
  return s
end

return {
  s({ trig = 't', dscr = 'tag' }, {
    t '<',
    i(1, 'tag'),
    t '>',
    i(2),
    t '</',
    f(function(args)
      return first_word(args[1][1])
    end, { 1 }),
    t '>',
  }),
  s('date', p(os.date, '%x')),
  s('time', p(os.date, '%H:%M')),
  s('datetime', p(os.date, '%x, %H:%M')),
  s('timestamp', p(os.date, '%c')),
}
