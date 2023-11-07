---@diagnostic disable: undefined-global

local M = {}

-- local same = require('my.utils.snippets').same

local preferred_quote = require('my.parameters').preferred_quote

local function concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

--  TODO: case, try, class, default, else, extends, import, with

for _, keyword in ipairs {
  'break;',
  'continue;',
  'delete ',
  'export ',
  'extends ',
  'instanceof ',
  'return ',
  'super',
  'super.',
  'this',
  'throw ',
  'typeof ',
  'void',
  'yield ',
} do
  table.insert(M, s(keyword, { t(keyword) }))
end

table.insert(
  M,
  s(
    'const',
    fmt('const [] = [];', { i(1, 'name'), i(2, '0') }, { delimiters = '[]' })
  )
)

table.insert(
  M,
  s(
    'let',
    fmt('let [] = [];', { i(1, 'name'), i(2, '0') }, { delimiters = '[]' })
  )
)


-- FIXME: indentation
table.insert(
  M,
  s('else', {
    c(1, {
      sn(1, { t { '} else {', '\t' }, i(1, '') }),
      sn(
        1,
        { t '} else if (', i(1, 'true'), t { ') {', '\t' }, i(2, '') }
      ),
    }),
  })
)

table.insert(
  M,
  s('else if', {
    c(1, {
      sn(
        1,
        { t '} else if (', i(1, 'true'), t { ') {', '\t' }, i(2, '') }
      ),
      sn(1, { t { '} else {', '\t' }, i(1, '') }),
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
        i(3, ''),
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
    'dot filter',
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
    'dot map',
    fmt(
      '.map(([]) => [][])',
      { i(1, 'identifier'), same(1), i(0) },
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
      { i(1, ''), i(2, 'ENOENT'), i(3, '') },
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
    'describe',
    fmt(
      [[
        describe("[]", () => {
          []
        })
      ]],
      { i(1, 'description'), i(2, '') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'it',
    fmt(
      [[
        it("[]", () => {
          []
        })
      ]],
      { i(1, 'description'), i(2, '') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'it async',
    fmt(
      [[
        it("[]", async () => {
          []
        })
      ]],
      { i(1, 'description'), i(2, '') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'expect toThrow',
    fmt(
      [[
        expect(() => { [] }).toThrow[]([]);
      ]],
      { i(1, '/* statement */'), i(2, ''), i(3, '') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'const style',
    fmt(
      [[

        export const [] = style({
          []
        });
      ]],
      { i(1, 'className'), i(2, '')},
      { delimiters = '[]' }
    )
  )
)

return M
