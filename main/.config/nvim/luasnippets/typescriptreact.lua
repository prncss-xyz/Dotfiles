---@diagnostic disable: undefined-global

local M = {}

local preferred_quote = require('my.parameters').preferred_quote

local function quote(str)
  return quote_char .. str .. quote_char
end

table.insert(
  M,
  s(
    'flex column',
    fmt([[display="flex" flexDirection="column" ]], {}, {
      delimiters = '[]',
    })
  )
)

table.insert(
  M,
  s(
    'flex row',
    fmt([[display="flex" flexDirection="row" ]], {}, {
      delimiters = '[]',
    })
  )
)

table.insert(
  M,
  s(
    'component',
    fmt(
      [[
        function []({[]}: {[]}) {
          return []
        }
      ]],
      {
        i(1, 'Name'),
        i(3, ''),
        i(2, ''),
        i(4, 'null'),
      },
      {
        delimiters = '[]',
      }
    )
  )
)

table.insert(
  M,
  s(
    'export component',
    fmt(
      [[
        export function []({[]}: {[]}) {
          return []
        }
      ]],
      {
        i(1, 'Name'),
        i(3, ''),
        i(2, ''),
        i(4, 'null'),
      },
      {
        delimiters = '[]',
      }
    )
  )
)

local function params(s)
  return s:gsub('(%s*%:%s*%w+%s*)', '')
end

return M
