---@diagnostic disable: undefined-global

local M = {
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
    i(2, '-- TODO:'),
    t { '', 'end' },
  }),
  s('s', {
    t 'function ',
    i(1),
    t '(',
    i(2),
    t ')',
    t { '', '  ' },
    i(3, '-- TODO:'),
    t { '', 'end' },
  }),
  s('i', {
    t 'if ',
    i(1, 'false'),
    t { ' then', '\t' },
    i(2, '-- TODO:'),
    t { '', 'end' },
  }),
  s('e', {
    c(1, {
      sn(1, { t { 'else', '\t' }, i(1, '-- TODO:') }),
      sn(
        1,
        { t 'elseif ', i(1, 'true'), t { ' then', '\t' }, i(2, '-- TODO:') }
      ),
    }),
  }),
  s('elseif', {
    c(1, {
      sn(
        1,
        { t 'elseif ', i(1, 'true'), t { ' then', '\t' }, i(2, '-- TODO:') }
      ),
      sn(1, { t { 'else', '\t' }, i(1, '-- TODO:') }),
    }),
  }),
}

table.insert(
  M,
  s(
    'local',
    fmt('local [] = []', {
      i(1, 'name'),
      i(2, '0'),
    }, { delimiters = '[]' })
  )
)

table.insert(
  M,
  s(
    'local require',
    fmt('local [] = require "[]"', {
      i(1, 'name'),
      i(2, 'module'),
    }, { delimiters = '[]' })
  )
)

table.insert(
  M,
  s(
    'repeat until',
    fmt(
      [[
        repeat
          []
        until []
      ]],
      {
        i(1, '-- TODO:'),
        i(2, 'false'),
      },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'for',
    fmt(
      [[
        for [] in [] do
         []
        end
      ]],
      {
        i(1, 'v'),
        i(2, 'iterator'),
        i(3, '-- TODO:'),
      },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'for pairs',
    fmt(
      [[
        for [], [] in pairs([]) do
          []
        end
      ]],
      {
        i(1, 'k'),
        i(2, 'v'),
        i(3, 'table_'), -- to makes sure lsp flags an undefined variable, and not unintentionnaly use builtin table
        i(4, '-- TODO:'),
      },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'for ipairs',
    fmt(
      [[
        for [], [] in ipairs([]) do
          []
        end
      ]],
      {
        i(1, 'i'),
        i(2, 'v'),
        i(3, 'list'),
        i(4, '-- TODO:'),
      },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'for line',
    fmt(
      [[
        f = io.open([])
        while true do
          local line = f:read()
          if line == nil then 
            break 
          end
          []
        end
      ]],
      {
        i(1, 'filepath'),
        i(2, '-- TODO:'),
      },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'forc',
    fmt(
      [[
        for [] = [], []  do
          []
        end
      ]],
      {
        i(1, 'i'),
        i(2, '1'),
        i(3, '10'),
        i(4, '-- TODO:'),
      },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'for char',
    fmt(
      [[
        for [] in str:gmatch '.' do
         []
        end
      ]],
      {
        i(1, 'char'),
        i(2, '-- TODO:'),
      },
      { delimiters = '[]' }
    )
  )
)

-- tests:

table.insert(
  M,
  s(
    'describe',
    fmt(
      [[
        describe("[]", function()
          []
        end)
      ]],
      { i(1, 'description'), i(2, '-- TODO:') },
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
        it("[]", function()
          []
        end)
      ]],
      { i(1, 'description'), i(2, '-- TODO:') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'test',
    fmt(
      [[
        describe("[]", function()
          it("[]", function())
            []
          end)
        end)
      ]],
      { i(1, 'description'), i(2, 'description'), i(2, '-- TODO:') },
      { delimiters = '[]' }
    )
  )
)

table.insert(
  M,
  s(
    'same',
    fmt(
      'assert.are.same([], [])',
      { i(1, 'expected'), i(2, 'passed') },
      { delimiters = '[]' }
    )
  )
)

return M
