local ls = require 'luasnip'
require('luasnip/loaders/from_vscode').lazy_load()

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

-- require('luasnip/loaders/from_vscode').lazy_load {
--   paths = os.getenv 'PROJECTS' .. '/closet',
-- }

local p = require('luasnip.extras').partial
--
-- not succeding to access system clipboard through LSP protocol
-- using vim api instead

local function clip_to_snip()
  local clip = vim.fn.getreg '+'
  local lines = {}
  for str in clip:gmatch '[^\r\n]+' do
    table.insert(lines, str)
  end
  local res = {}
  local sp = ''
  for _ = 1, vim.bo.tabstop or 1 do
    sp = sp .. ' '
  end
  for j, line in ipairs(lines) do
    local pre = ''
    line = line:gsub('^[ \t]+', function(str)
      pre = str
      pre = pre:gsub('\t', '\\t')
      pre = pre:gsub(sp, '\\t')
      return ''
    end)
    local str = string.format('%q', line)
    str = str:sub(2, #str - 1)
    table.insert(res, t '\t\t"')
    table.insert(res, t(pre))
    table.insert(res, i(j, str))
    table.insert(res, t '"')
    if j < #lines then
      table.insert(res, t ',')
    end
    table.insert(res, t { '', '' })
  end
  return sn(nil, res)
end

local function bash(_, command)
  local file = io.popen(command, 'r')
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

ls.snippets = {
  TEMPLATES = {
    s(
      { trig = '*.lua' },
      { t { 'local m = {}', '', '' }, i(0), t { '', '', 'return m' } }
    ),
    s({ trig = '*/.local/bin/*.*' }, {}),
    s({
      trig = '*/.local/bin/*',
    }, {
      t '#!/usr/bin/env sh',
      t { '', '' },
    }),
  },
  lua = {
    s({ trig = 'snippet' }, {
      t "s( {trig = '",
      i(1, 'trigger'),
      t { "'}, {", '\t' },
      i(2, '-- contents'),
      t { '', '' },
      t { '}),', '' },
    }),
  },
  all = {
    s('date', p(os.date, '%x')),
    s('time', p(os.date, '%H:%M')),
    s('datetime', p(os.date, '%x, %H:%M')),
    s('timestamp', p(os.date, '%c')),
  },
  fish = {
s( {trig = 'if'}, {
  -- contents
}),

  },
  json = {
    -- this snippet generates a textmate snippet from clipboard content
    s({ trig = 'snippet' }, {
      t '"',
      i(1, 'name'),
      t { '": {', '' },
      t { '\t"prefix": "' },
      i(2, 'prefix'),
      t { '",', '' },
      t { '\t"description": "' },
      i(3, 'description'),
      t { '",', '' },
      t { '\t"body": [', '' },
      d(4, clip_to_snip, {}),
      t { '\t]', '},' },
    }),
  },
  -- makes file executable as a side effect
  javascript = {
    s({
      trig = 'shebang',
    }, {
      t '#!/usr/bin/env node',
      f(function()
        vim.cmd 'Chmod +x'
        return ''
      end, {}),
      t { '', '' },
    }),
  },
}

require 'templates'
