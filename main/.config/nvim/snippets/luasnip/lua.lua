---@diagnostic disable: undefined-global

local preferred_quote = require('parameters').preferred_quote

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
  s('f', {
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

-- cheat:

table.insert(
  M,
  s(
    'cht: iterate characters in string',
    fmt(
      [[
    for [] in str:gmatch '.' do
      []
    end]],
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
        describe("[]", function())
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
        it("[]", function())
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
        describe("[]", function())
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
      { i(1, 'passed'), i(2, 'expected') },
      { delimiters = '[]' }
    )
  )
)

return M
