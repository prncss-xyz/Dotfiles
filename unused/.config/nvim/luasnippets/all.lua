---@diagnostic disable: undefined-global

local preferred_quote = require('my.parameters').preferred_quote

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
        t ' >',
        r(3, 'children'),
        t '</',
        f(function(args)
          return args[1][1]
        end, { 1 }),
        t '>',
      }),
      sn(nil, {
        t '<',
        r(1, 'tag'),
        t ' ',
        r(2, 'attrs'),
        t ' />',
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

if false then
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

--FIX: avoid adding comment inside comment
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
local get_cstring = function(ctype)
  local calculate_comment_string = require('Comment.ft').calculate
  local utils = require 'Comment.utils'
  -- use the `Comments.nvim` API to fetch the comment string for the region (eq. '--%s' or '--[[%s]]' for `lua`)
  local cstring = calculate_comment_string {
    ctype = ctype,
    range = utils.get_region(),
  } or vim.bo.commentstring
  -- as we want only the strings themselves and not strings ready for using `format` we want to split the left and right side
  return utils.unwrap_cstr(cstring)
end

table.insert(
  M,
  s({ trig = 'c', descr = 'comment' }, {
    d(1, function()
      local lc, rc = get_cstring 'line'
      -- local lc, rc = '<<', '>>'
      return sn(nil, { t(lc), i(1, 'comment'), t(rc) })
    end, {}),
  })
)

table.insert(
  M,
  s({ trig = 'cc', descr = 'multiline comment' }, {
    d(1, function()
      local lc, rc = get_cstring 'block'
      return sn(nil, { t(lc), i(1, 'comment'), t(rc) })
    end, {}),
  })
)

local function todo_comment(str)
  table.insert(
    M,
    s(str .. ' comment', {
      d(1, function()
        local lc, rc = get_cstring 'line'
        return sn(nil, { t(lc), t(str .. ': '), i(1, ''), t(rc) })
      end, {}),
    })
  )
end

-- trying to keep TODO comments consistent with standard commit messages
for _, k in ipairs {
  'BUILD',
  'CI',
  'DOCS',
  'FEAT',
  'REFACT',
  'STYLE',
  'TEST',
  'QUESTION',
  'FIX',
  'ISSUE',
  'TODO',
  'HACK',
  'WARN',
  'PERF',
  'NOTE',
  'WAIT',
} do
  todo_comment(k)
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

table.insert(
  M,
  s('shebang', {
    d(1, function()
      chmod_x()
      return sn(1, { t '#!/usr/bin/env ', i(1, env[vim.bo.filetype] or 'env') })
    end, {}),
    t { '', '' },
    i(0, ''),
  }, {
    callbacks = {
      -- index `-1` means the callback is on the snippet as a whole
      [-1] = {
        [events.leave] = function()
          require('khutulun').chmod_x()
        end,
      },
    },
  })
)

--FIX: not working
local conds_expand = require 'luasnip.extras.conditions.expand'
table.insert(
  M,
  s('cond_bol', {
    t 'will only expand at the beginning of the line',
  }, {
    condition = function()
      return false
    end,
  })
)

return M
