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
local l = require('luasnip.extras').lambda

local function li(n, cb, ...)
  local str = cb(...)
  return d(n, function()
    return sn(nil, { i(1, str) })
  end, {})
end

local split_string = require('modules.utils').split_string

local M = {
  s(
    { trig = '*.lua' },
    { t { 'local M = {}', '', '' }, i(0), t { '', '', 'return M' } }
  ),
  s({ trig = '*/.local/bin/*.*' }, {}),
  s({
    trig = '*/.local/bin/*',
  }, {
    t '#!/usr/bin/env sh',
    t { '', '' },
  }),
}

local prettierrc = [[trailingComma: "all"
quoteProps: "consistent"
jsxSingleQuote: true
singleQuote: true]]
table.insert(
  M,
  s({ trig = '.prettierrc.yaml' }, { t(split_string(prettierrc, '\n')) })
)

local eslintrc = [[module.exports = {
  settings: {
    react: { version: 'detect' },
  },
  env: {
    es2020: true,
    node: true,
  },
  parserOptions: {
    sourceType: 'module',
  },
  extends: ['eslint:recommended', 'plugin:react/recommended', 'prettier'],
  rules: { 'react/prop-types': 0 },
};]]
table.insert(
  M,
  s({ trig = '.eslintrc.js' }, { t(split_string(eslintrc, '\n')) })
)

local selene = [[std="lua51+vim+xplr"]]
table.insert(M, s({ trig = 'selene.toml' }, { t(split_string(selene, '\n')) }))

local stylua = [[column_width = 80
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferSingle"
no_call_parentheses = false]]
table.insert(M, s({ trig = 'stylua.toml' }, { t(split_string(stylua, '\n')) }))

local busted = [[return {
  _all = {
    coverage = false
  },
  default = {
    verbose = true,
    ROOT = {"."}
  }
}]]
table.insert(M, s({ trig = '.busted' }, { t(split_string(busted, '\n')) }))

local function title()
  local pat = split_string(vim.fn.expand '%:p:h', '/')
  pat = pat[#pat]
  return pat
end

local function year()
  return os.date '%Y'
end

local cache_name
local function name()
  if not cache_name then
    -- git config --get user.name
    local Job = require 'plenary.job'
    Job
      :new({
        command = 'git',
        args = { 'config', '--get', 'user.name' },
        cwd = os.getenv 'HOME',
        on_exit = function(j, return_val)
          cache_name = j:result()[1] or 'name'
        end,
      })
      :sync() -- or start()
  end
  return cache_name
end

table.insert(
  M,
  s({ trig = 'README.md' }, {
    t { '# ' },
    li(1, title),
    t { '', '', '' },
    i(2, '...'),
  })
)

-- TODO: placeholders
local license =
  [[Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.]]

table.insert(
  M,
  s({ trig = 'LICENSE' }, {
    t 'Copyright ',
    li(1, year),
    t ' ',
    li(2, name),
    t { ' ', '', '' },
    t(split_string(license, '\n')),
  })
)

local function module(pattern)
  local filename = vim.fn.expand '%'
  return filename:match(pattern)
end

-- TODO: testing snippets

table.insert(
  M,
  s({ trig = '*_spec.lua' }, {
    t 'local ',
    i(1, 'M'),
    t " = require '",
    p(module, '(.+)_spec.lua$'),
    t { "'", '', '' },
    i(2, '-- tests'),
  })
)

table.insert(
  M,
  s({ trig = '*_spec.lua' }, {
    t 'local ',
    i(1, 'M'),
    t " = require '",
    p(module, '(.+)_spec.lua$'),
    t { "'", '', '' },
    i(2, '-- tests'),
  })
)

table.insert(
  M,
  s({ trig = '*.test.js' }, {
    t 'import ',
    i(1, 'M'),
    t " from './",
    p(module, '(.+).test.js$'),
    t { "';", '', '' },
    i(2, '// tests'),
  })
)

table.insert(
  M,
  s({ trig = '*.test.ts' }, {
    t 'import ',
    i(1, 'M'),
    t " from './",
    p(module, '(.+).test.ts$'),
    t { "';", '', '' },
    i(2, '// tests'),
  })
)

table.insert(
  M,
  s({ trig = '*.test.jsx' }, {
    t {
      "import React from 'react';",
      "import renderer from 'react-test-renderer';",
      'import ',
    },
    i(1, 'M'),
    t " from './",
    p(module, '(.+).test.jsx$'),
    t { "';", '', '' },
    i(2, '// tests'),
  })
)

table.insert(
  M,
  s({ trig = '*.test.tsx' }, {
    t {
      "import React from 'react';",
      "import renderer from 'react-test-renderer';",
      'import ',
    },
    i(1, 'M'),
    t " from './",
    p(module, '(.+).test.tsx$'),
    t { "';", '', '' },
    i(2, '// tests'),
  })
)

return M
