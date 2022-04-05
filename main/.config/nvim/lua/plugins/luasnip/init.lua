local ls = require 'luasnip'

require('luasnip/loaders/from_vscode').lazy_load()

local split_string = require('modules.utils').split_string

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local isn = ls.indent_snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local p = require('luasnip.extras').partial

local function first_word(s)
  local i = s:find(' ', 1, true)
  if i then
    return s:sub(1, i - 1)
  end
  return s
end

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

ls.add_snippets('fish', require 'plugins.luasnip.fish')
ls.add_snippets('all', {
  s({ trig = 't', dscr = 'tag' }, {
    t '<',
    i(1, 'tag'),
    t '>',
    i(2),
    t '</',
    f(function(args)
      return first_word(args[1][1])
    end, { 1 }),
    t '>',
  }),
  s('date', p(os.date, '%x')),
  s('time', p(os.date, '%H:%M')),
  s('datetime', p(os.date, '%x, %H:%M')),
  s('timestamp', p(os.date, '%c')),
})
ls.add_snippets('lua', {
  s({ trig = 'k' }, {
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
  }),
  s({ trig = 'y' }, {
    t 'if ',
    i(1, 'true'),
    t ' then',
    t { '', '' },
    i(2),
    t { '', 'end', '' },
  }),
  s({ trig = 'z' }, {
    t 'while ',
    i(1, 'true'),
    t ' do',
    t { '', '' },
    i(2),
    t { '', 'end' },
  }),
  s({ trig = 'f' }, {
    t 'local function ',
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
    t { '', '  ' },
    i(3),
    t { '', 'end', '' },
  }),
})
ls.add_snippets('javascript', {
  s({ trig = 'k' }, {
    i(1, 'name'),
    t '(',
    i(2),
    t ')',
  }),
  s({ trig = 'y' }, {
    t 'if (',
    i(1, 'true'),
    t ') {',
    t { '', '' },
    i(2),
    t { '', '}', '' },
  }),
  s({ trig = 'z' }, {
    t 'while (',
    i(1, 'true'),
    t ') {',
    t { '', '' },
    i(2),
    t { '', '}' },
  }),
  s({ trig = 'f' }, {
    t 'function ',
    i(1, 'name'),
    t '(',
    i(2),
    t ') {',
    t { '', '  ' },
    i(3),
    t { '', '}', '' },
  }),
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
})
ls.add_snippets('json', {
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
})

ls.config.set_config { history = true, enable_autosnippets = false }
