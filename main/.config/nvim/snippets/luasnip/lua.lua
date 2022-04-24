---@diagnostic disable: undefined-global

return {
  s({ trig = 'k' }, {
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
  }),
  s({ trig = 'l' }, { t 'local ' }),
  s({ trig = 'r' }, { t 'return ' }),
  s({ trig = 'w' }, {
    t 'while ',
    i(1, 'true'),
    t { ' do', '\t' },
    i(2, '-- block'),
    t { '', 'end' },
  }),
  s({ trig = 'f' }, {
    t 'function ',
    i(1),
    t '(',
    i(2),
    t ')',
    t { '', '  ' },
    i(3, '-- block'),
    t { '', 'end' },
  }),
  s({ trig = 'i' }, {
    t 'if ',
    i(1, 'false'),
    t { ' then', '\t' },
    i(2, '-- block'),
    t { '', 'end'},
  }),
  s({ trig = 'e' }, {
    c(1, {
      sn(1, { t { 'else', '\t' }, i(1, '-- block') }),
      sn(
        1,
        { t 'elseif ', i(1, 'true'), t { ' then', '\t' }, i(2, '-- block') }
      ),
    }),
  }),
  s({ trig = 'elseif' }, {
    c(1, {
      sn(
        1,
        { t 'elseif ', i(1, 'true'), t { ' then', '\t' }, i(2, '-- block') }
      ),
      sn(1, { t { 'else', '\t' }, i(1, '-- block') }),
    }),
  }),
}
