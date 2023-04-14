local M = {}

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
local r = ls.restore_node
local fmt = require('luasnip.extras.fmt').fmt

local capture = require('flies.utils.buffers').snip_capture

M.b = {
  left = '(',
  right = ')',
}

M.i = {
  snip = {
    javascript = s(
      '',
      fmt(
        [[
          if ([]) {
            []
          }
        ]],
        {
          i(1, 'true'),
          capture 'contents',
        },
        { delimiters = '[]' }
      )
    ),
    lua = s(
      '',
      fmt(
        [[
          if [] then
            []
          end
        ]],
        {
          i(1, 'true'),
          capture 'contents',
        },
        { delimiters = '[]' }
      )
    ),
  },
}

M.k = {
  snip = {
    default = s('', { i(1, 'name'), t '(', capture 'contents', t ')' }),
  },
}

M.l = {
  snip = {
    javascript = s(
      '',
      fmt(
        [[
          while ([]) {
            []
          }
        ]],
        {
          i(1, 'true'),
          capture 'contents',
        },
        { delimiters = '[]' }
      )
    ),
    lua = s(
      '',
      fmt(
        [[
          while [] do
            []
          end
        ]],
        {
          i(1, 'true'),
          capture 'contents',
        },
        { delimiters = '[]' }
      )
    ),
  },
}

M.q = {
  left = '"',
  right = '"',
}

M.s = {
  snip = {
    javascript = s(
      '',
      fmt(
        [[
          function []([]) {
            []
          }
        ]],
        {
          i(1, 'name'),
          i(2, ''),
          capture 'contents',
        },
        { delimiters = '[]' }
      )
    ),
    lua = s(
      '',
      fmt(
        [[
          function []([])
            []
          end
        ]],
        {
          i(1, 'name'),
          i(2, ''),
          capture 'contents',
        },
        { delimiters = '[]' }
      )
    ),
  },
}

M.t = {
  snip = {
    default = s(
      '',
      fmt('<[]>[]</[]>', {
        i(1, 'tag'),
        capture 'contents',
        f(function(args)
          local text = args[1][1] or ''
          print('function text:', vim.inspect(text)) -- __AUTO_GENERATED_PRINT_VAR__
          return text:match '%w+'
        end, 1),
      }, { delimiters = '[]' })
    ),
  },
}

M.v = {
  left = '_',
  right = '_',
}

M.w = {
  left = ' ',
  right = ' ',
}

return M
