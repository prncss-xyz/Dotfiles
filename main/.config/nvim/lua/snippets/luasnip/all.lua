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

local function first_word(s)
  local i = s:find(' ', 1, true)
  if i then
    return s:sub(1, i - 1)
  end
  return s
end

local M = {
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
}

local function get_comment(ctype)
  local U = require 'Comment.utils'
  local cursor = vim.api.nvim_win_get_cursor(0)
  local range = {
    srow = cursor[1],
    scol = cursor[2],
    erow = cursor[1],
    ecol = cursor[2],
  }
  local ctx = {
    cmode = U.cmode.comment,
    cmotion = ctype == 'line' and U.cmotion.char or U.cmotion.line,
    ctype = ctype == 'line' and U.ctype.line or U.ctype.block,
    range = range,
  }
  local Config = require 'Comment.config'
  local cfg = Config:get()
  local lcs, rcs = U.parse_cstr(cfg, ctx)
  lcs = lcs and lcs .. ' ' or ''
  rcs = rcs and ' ' .. rcs or ''
  return lcs, rcs
end

table.insert(
  M,
  s({ trig = 'c', descr = 'comment' }, {
    d(1, function()
      local lc, rc = get_comment 'line'
      return sn(1, { t(lc), i(1, 'comment'), t(rc) })
    end, {}),
  })
)

table.insert(
  M,
  s({ trig = 'cc', descr = 'multiline comment' }, {
    d(1, function()
      local lc, rc = get_comment 'block'
      return sn(1, { t(lc), i(1, 'comment'), t(rc) })
    end, {}),
  })
)

local function todo_comment(str)
  return {
    d(1, function()
      local lc, rc = get_comment 'line'
      return sn(nil, { t(lc), t(str .. ': '), i(1, ''), t(rc) })
    end, {}),
  }
end

for _, str in ipairs { 'TODO', 'HACK', 'WARN', 'PERF', 'NOTE', 'FIXME' } do
  table.insert(M, s({ trig = 'c' .. str .. ':', descr = str }, todo_comment(str)))
  -- needs this to write a todo comment while already in a comment
  table.insert(M, s({ trig = str .. ':', descr = str }, {t (str .. ': ')}))
end

return M
