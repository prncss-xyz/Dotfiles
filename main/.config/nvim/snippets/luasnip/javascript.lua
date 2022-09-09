---@diagnostic disable: undefined-global
--

local quote_char = "'"

local function concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

local function test(s)
  local res = {
    t { 'test(' .. quote_char },
    i(1, 'description'),
    t { quote_char .. ') => {' },
  }
  concat(res, s)
  concat(res, { t '}' })
  return res
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
    'lambda',
    fmt('([]) => []', { i(1, '_params'), i(2, '0') }, { delimiters = '[]' })
  )
)

table.insert(
  M,
  s(
    'f',
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

table.insert(M, s('test', test { t 'test' }))

table.insert(
	M,
	s(
		"rethrow",
		fmt(
			[[
        try {
          []
        } catch (error) {
          if (error.code !== "[]") throw error;[]
        }
      ]],
			{ i(1, "// TODO:"), i(2, "ENOENT"), i(3, "") },
			{
				delimiters = "[]",
			}
		)
	)
)

return M
