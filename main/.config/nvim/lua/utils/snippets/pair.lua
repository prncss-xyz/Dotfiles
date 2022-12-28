local M = {}

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---pairs
function M.char_count_smaller(c1, c2)
  dump 'condition' --FIX: not triggerd
  local line = vim.api.nvim_get_current_line()
  -- '%'-escape chars to force explicit match (gsub accepts patterns).
  -- second return value is number of substitutions.
  local _, ct1 = string.gsub(line, '%' .. c1, '')
  local _, ct2 = string.gsub(line, '%' .. c2, '')
  return ct1 < ct2
end

function M.odd_count(c)
  dump 'condition' --FIX: not triggerd
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, c, '')
  return ct % 2 == 1
end

function M.pair(pair_begin, pair_end, condition)
  -- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
  -- ... is used to pass any args following the expand_func to it.
  return
    s({ trig = pair_begin, wordTrig = false }, {
      t { pair_begin },
      i(1),
      t { pair_end },
    }, {
      -- type = 'autosnippets',
      condition = function()
        return condition(pair_begin, pair_end)
      end,
    })
end

return M
