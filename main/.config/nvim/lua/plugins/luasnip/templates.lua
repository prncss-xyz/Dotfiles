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
    return sn(1, { i(1, str) })
  end, {})
end

-- TODO: use regex trigger
-- prioritize first matching snippet
-- exact string matches filename only (no dir)
-- regex matches against whole path

local split_string = require('utils').split_string

local M = {}

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

return M
