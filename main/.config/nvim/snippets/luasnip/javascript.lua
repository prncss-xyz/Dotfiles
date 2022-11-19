---@diagnostic disable: undefined-global

local preferred_quote = require('parameters').preferred_quote

local function concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

local M = {}

table.insert(
  M,
  s({ trig = 'i' }, {
    t 'if (',
    i(1, 'false'),
    t { ') {', '\t ' },
    i(2, '// block'),
    t { '', '}' },
  })
)

table.insert(
  M,
  s({ trig = 'k' }, {
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
  })
)

table.insert(
  M,
  s(
    's',
    fmt(
      [[
      function []([]) {
        []
      }
    ]],
      { i(1, 'name'), i(2, '_params'), i(3, '// TODO:') },
      { delimiters = '[]' }
    )
  )
)

table.insert(M, s({ trig = 'r' }, { t 'return ' }))

table.insert(
  M,
  s({ trig = 'w' }, {
    t 'while (',
    i(1, 'true'),
    t { ') {', '\t' },
    i(2, '// block'),
    t { '', '}' },
  })
)

-- FIXME: indentation
table.insert(
  M,
  s({ trig = 'e' }, {
    c(1, {
      sn(1, { t { '} else {', '\t' }, i(1, '// block') }),
      sn(
        1,
        { t '} else if (', i(1, 'true'), t { ') {', '\t' }, i(2, '// block') }
      ),
    }),
  })
)

--

table.insert(
  M,
  s({ trig = 'else if' }, {
    c(1, {
      sn(
        1,
        { t '} else if (', i(1, 'true'), t { ') {', '\t' }, i(2, '// block') }
      ),
      sn(1, { t { '} else {', '\t' }, i(1, '// block') }),
    }),
  })
)

table.insert(
  M,
  s(
    'async funtion',
    fmt(
      [[
        async function []([]) {
          []
        }
      ]],
      {
        i(1, 'name'),
        i(2, ''),
        i(3, '// TODO:'),
      },
      { delimiters = '[]' }
    )
  )
)

table.insert(M, s('export', fmt('export ', {}, { delimiters = '[]' })))
table.insert(
  M,
  s('export default', fmt('export default ', {}, { delimiters = '[]' }))
)

table.insert(
  M,
  s(
    '.filter',
    fmt(
      '.filter(([]) => [])',
      { i(1, 'identifier'), i(2, 'true') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    '.map',
    fmt(
      '.map(([]) => [])',
      { i(1, 'identifier'), i(2, 'indentifier') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'lambda',
    fmt('([]) => []', { i(1, '_params'), i(2, '0') }, { delimiters = '[]' })
  )
)

table.insert(
  M,
  s(
    'lambda async',
    fmt(
      'async ([]) => []',
      { i(1, '_params'), i(2, '0') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'lambda return',
    fmt(
      [[
      ([]) => {
        return []
      }
    ]],
      { i(1, '_params'), i(2, '0') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'lambda async return',
    fmt(
      [[
      async ([]) => {
        return []
      }
    ]],
      { i(1, '_params'), i(2, '0') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'rethrow',
    fmt(
      [[
        try {
          []
        } catch (error) {
          if (error.code !== "[]") throw error;[]
        }
      ]],
      { i(1, '// TODO:'), i(2, 'ENOENT'), i(3, '') },
      {
        delimiters = '[]',
      }
    )
  )
)

-- Testing

table.insert(
  M,
  s(
    { trig = 'describe' },
    fmt(
      [[
        describe("[]", () => {
          []
        })
      ]],
      { i(1, 'description'), i(2, '// block') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    { trig = 'it' },
    fmt(
      [[
        it("[]", () => {
          []
        })
      ]],
      { i(1, 'description'), i(2, '// block') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    { trig = 'it async' },
    fmt(
      [[
        it("[]", async () => {
          []
        })
      ]],
      { i(1, 'description'), i(2, '// block') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    { trig = 'expect toThrow' },
    fmt(
      [[
        expect(() => { [] }).toThrow[]([]);
      ]],
      { i(1, '/* statement */'), i(2, ''), i(3, '') },
      { delimiters = '[]' }
    )
  )
)

return M
