---@diagnostic disable: undefined-global

local preferred_quote = require('parameters').preferred_quote

return {
  s('k', {
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
  }),
  s('l', { t 'local ' }),
  s('r', { t 'return ' }),
  s('w', {
    t 'while ',
    i(1, 'true'),
    t { ' do', '\t' },
    i(2, '-- block'),
    t { '', 'end' },
  }),
  s('f', {
    t 'function ',
    i(1),
    t '(',
    i(2),
    t ')',
    t { '', '  ' },
    i(3, '-- block'),
    t { '', 'end' },
  }),
  s('i', {
    t 'if ',
    i(1, 'false'),
    t { ' then', '\t' },
    i(2, '-- block'),
    t { '', 'end' },
  }),
  s('e', {
    c(1, {
      sn(1, { t { 'else', '\t' }, i(1, '-- block') }),
      sn(
        1,
        { t 'elseif ', i(1, 'true'), t { ' then', '\t' }, i(2, '-- block') }
      ),
    }),
  }),
  s('elseif', {
    c(1, {
      sn(
        1,
        { t 'elseif ', i(1, 'true'), t { ' then', '\t' }, i(2, '-- block') }
      ),
      sn(1, { t { 'else', '\t' }, i(1, '-- block') }),
    }),
  }),
  s(
    'cht: iterate characters in string',
    fmt(
      [[
    for {} in str:gmatch '.' do
      {}
    end]],
      {
        i(1, 'char'),
        i(2, '-- block'),
      }
    )
  ),
}
