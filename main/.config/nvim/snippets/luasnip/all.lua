---@diagnostic disable: undefined-global

local M = {
  s('date', p(os.date, '%x')),
  s('time', p(os.date, '%H:%M')),
  s('datetime', p(os.date, '%x, %H:%M')),
  s('timestamp', p(os.date, '%c')),
}
table.insert(
  M,
  s('t', {
    c(1, {
      sn(nil, {
        t '<',
        r(1, 'tag'),
        t ' ',
        r(2, 'attrs'),
        t ' />',
      }),
      sn(nil, {
        t '<',
        r(1, 'tag'),
        t ' ',
        r(2, 'attrs'),
        t ' >',
        r(3, 'children'),
        t '</',
        f(function(args)
          return args[1][1]
        end, { 1 }),
        t '>',
      }),
    }),
  }, {
    stored = {
      tag = i(1, 'tag'),
      attrs = i(1, ''),
      children = i(1, ''), -- probably useless
    },
  })
)

if true then
  table.insert(
    M,
    s('b', {
      c(1, {
        sn(nil, { t '{', r(1, 'user_text'), t '}' }),
        sn(nil, { t '[', r(1, 'user_text'), t ']' }),
        sn(nil, { t '(', r(1, 'user_text'), t ')' }),
      }),
    }, {
      stored = {
        user_text = i(1, ''),
      },
    })
  )

  table.insert(
    M,
    s('q', {
      c(1, {
        sn(nil, { t '`', r(1, 'user_text'), t '`' }),
        sn(nil, { t "'", r(1, 'user_text'), t "'" }),
        sn(nil, { t '"', r(1, 'user_text'), t '"' }),
      }),
    }, {
      stored = {
        user_text = i(1, ''),
      },
    })
  )
end

-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets
local calculate_comment_string = require('Comment.ft').calculate
local region = require('Comment.utils').get_region
local ctype_enum = require('Comment.utils').ctype

local function get_comment(ctype_string)
  -- Don't add comment string inside a comment
  local context = require 'cmp.config.context'
  if
    context.in_treesitter_capture 'comment'
    or context.in_syntax_group 'Comment'
  then
    return '', ''
  end

  local cstring = calculate_comment_string {
    ctype = ctype_enum[ctype_string],
    range = region(),
  } or ''
  local lcs, rcs = unpack(
    vim.split(cstring, '%s', { plain = true, trimempty = true })
  )
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
  -- needs this to write a todo comment while already in a comment
  table.insert(
    M,
    s({ trig = str .. ' comment', descr = str }, todo_comment(str))
  )
end

_G.if_char_insert_space = function()
  if string.find(vim.v.char, '%a') then
    vim.v.char = ' ' .. vim.v.char
  end
end

table.insert(
  M,
  s('mk', {
    t '$',
    i(1),
    t '$',
  }, {
    callbacks = {
      -- index `-1` means the callback is on the snippet as a whole
      [-1] = {
        [events.leave] = function()
          vim.cmd [[
            autocmd InsertCharPre <buffer> ++once lua _G.if_char_insert_space()
          ]]
        end,
      },
    },
  })
)

local env = {
  javascript = 'node',
}

local function chmod_x()
  local filename = vim.fn.expand('%', nil, nil)
  local perm = vim.fn.getfperm(filename)
  local res = ''
  local r
  for j = 1, perm:len() do
    local char = perm:sub(j, j)
    if j % 3 == 1 then
      r = char == 'r'
    end
    if j % 3 == 0 and r then
      char = 'x'
    end
    res = res .. char
  end
  vim.fn.setfperm(filename, res)
end

table.insert(
  M,
  s({
    trig = 'shebang',
  }, {
    d(1, function()
      chmod_x()
      return sn(1, { t '#!/usr/bin/env ', i(1, env[vim.bo.filetype] or 'env') })
    end, {}),
    t { '', '' },
    i(0, ''),
  })
)

local sample = fmt(
  [[
bah
  '{}'
blop
]],
  { i(1, 'toto') }
)

table.insert(M, s('sample', sample))

return M
