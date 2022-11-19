local M = {}

-- TODO: make a plugin
-- TODO: repeatable
-- TODO: bufnr param
-- TODO: use coordinates
-- TODO: implement ts

-- utils

local function cmp_tuples(t1, t2)
  local i = 1
  while true do
    local v1, v2 = t1[i], t2[i]
    if v1 == nil and v2 == nil then
      return 0
    end
    if v1 == nil then
      return -1
    end
    if v2 == nil then
      return 1
    end
    if v1 < v2 then
      return -1
    end
    if v2 > v1 then
      return 1
    end
    i = i + 1
  end
end

-- api

local function get_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  cursor[2] = cursor[2] + 1
  return cursor
end

local function get_line(row)
  return vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
end

local function snip_replace(snippet, from, to_, expand_params)
  require('luasnip').snip_expand(snippet, {
    clear_region = {
      from = { from[1] - 1, from[2] - 1 },
      to = { to_[1] - 1, to_[2] },
    },
    expand_params = expand_params,
  })
end

local function get_lsp_range(s, e)
  local start
  if vim.deep_equal(s, {}) then
    start = { line = e[1] - 1, character = e[2] }
  else
    start = { line = s[1] - 1, character = s[2] - 1 }
  end
  local end_
  if vim.deep_equal(e, {}) then
    end_ = { line = s[1] - 1, character = s[2] - 1 }
  else
    end_ = { line = e[1] - 1, character = e[2] }
  end
  return { start = start, ['end'] = end_ }
end

local function get_lsp_edit(edit)
  local from, to_, new_text = unpack(edit)
  return { range = get_lsp_range(from, to_), newText = new_text }
end

local function text_replace(edits)
  vim.lsp.util.apply_text_edits(vim.tbl_map(get_lsp_edit, edits), 0, 'utf-8')
end

-- specific

function sample_snip()
  local ls = require 'luasnip'
  local s = ls.snippet
  local sn = ls.snippet_node
  local isn = ls.indent_snippet_node
  local t = ls.text_node
  local i = ls.insert_node
  local f = ls.function_node
  local c = ls.choice_node
  local d = ls.dynamic_node
  local r = ls.restore_node
  local events = require 'luasnip.util.events'
  local ai = require 'luasnip.nodes.absolute_indexer'
  local fmt = require('luasnip.extras.fmt').fmt
  local m = require('luasnip.extras').m
  local lambda = require('luasnip.extras').l
  return s('k', { i(1, 'name'), t '(', i(2), t ')' })
end

local conf = {
  lookahead = 200,
  replacers = {
    ascend = {
      {
        type = 'lua',
        patterns = { '^#+ .*$' },
        replace = function(trigger)
          return '#' .. trigger
        end,
        filetypes = { 'markdown' },
      },
      {
        type = 'lua',
        patterns = { '%d+' },
        replace = function(trigger)
          return tostring(tonumber(trigger) + vim.v.count1)
        end,
      },
      {
        type = 'lua',
        patterns = { '%f[%w]true%f[%W]' },
        replace = 'false',
      },
      {
        type = 'lua',
        patterns = { '%f[%w]false%f[%W]' },
        replace = 'true',
      },
    },
    descend = {
      {
        type = 'lua',
        patterns = { '^##+ .*$' },
        replace = function(trigger)
          return trigger:sub(2)
        end,
        filetypes = { 'markdown' },
      },
      {
        type = 'lua',
        patterns = { '%d+' },
        replace = function(trigger)
          return tostring(tonumber(trigger) - vim.v.count1)
        end,
      },
      {
        type = 'lua',
        patterns = { '%f[%w]true%f[%W]' },
        replace = 'false',
      },
      {
        type = 'lua',
        patterns = { '%f[%w]false%f[%W]' },
        replace = 'true',
      },
    },
  },
}

local function get_cmp_match(col)
  local function c(t)
    local s, e = unpack(t)
    return {
      s <= col and 0 or 1,
      s,
      -e,
    }
  end

  return function(t1, t2)
    return cmp_tuples(c(t1), c(t2))
  end
end

local function cmp_multi_pat_matches_f(t)
  local s, e = unpack(t)
  return { s, -e }
end

local function cmp_multi_pat_matches(t1, t2)
  return cmp_tuples(cmp_multi_pat_matches_f(t1), cmp_multi_pat_matches_f(t2))
end

local function multi_pat_matches(patterns, line)
  local results = {}
  local n = 0
  for i, pattern in ipairs(patterns) do
    local s, e = line:find(pattern, 1)
    dump(i, pattern, s, e)
    if s then
      results[i] = { s, e }
    end
    n = i
  end
  dump(results)

  return function()
    local best_i, best_result
    for i = 1, n do
      local result = results[i]
      if result then
        if not best_i or cmp_multi_pat_matches(result, best_result) == -1 then
          best_i, best_result = i, result
        end
      end
    end
    if best_i then
      local s, e = line:find(patterns[best_i], best_result[2] + 1)
      if s then
        results[best_i] = { s, e }
      else
        results[best_i] = nil
      end
      return best_i, best_result
    end
  end
end

local function pat_matches(pattern, line)
  local i = 1
  return function()
    local s, e = line:find(pattern, i)
    if not s then
      return
    end
    i = e + 1
    return { s, e }
  end
end

local function find_best_match(entries, line, col)
  local cmp = get_cmp_match(col)
  local best_match, best_entry, best_pattern
  for _, entry in ipairs(entries) do
    if not entry.filetypes or vim.tbl_contains(entry.filetypes, vim.bo.filetype)
    then
      for _, pattern in ipairs(entry.patterns) do
        for match in pat_matches(pattern, line) do
          if match[2] >= col and (not best_match or cmp(match, best_match) == 1)
          then
            best_match, best_entry, best_pattern = match, entry, pattern
          end
        end
      end
    end
  end
  return best_match, best_entry, best_pattern
end

local function replace(entries)
  local cursor = get_cursor()
  for i = 1, conf.lookahead do
    local row = cursor[1] + i - 1
    local col = i == 1 and cursor[2] or 1
    local line = get_line(row)
    local match, entry, pattern = find_best_match(entries, line, col)
    if match then
      local s = match[1]
      local new_text = line:sub(s):gsub(pattern, entry.replace, 1)
      text_replace {
        {
          { row, s },
          { row, line:len() },
          new_text,
        },
      }
      return
    end
  end
end

function M.replace(label)
  if label then
    local entries = conf.replacers[label]
    assert(
      entries,
      string.format('Cannot find configuration for label %q', label)
    )
    replace(entries)
  else
    local keys = {}
    for key in pairs(conf.replacers) do
      table.insert(keys, key)
    end
    vim.ui.select(
      keys,
      { prompt = 'longnose: choose replacer' },
      function(label_)
        if not label_ then
          return
        end
        local entries = conf.replacers[label_]
        replace(entries)
      end
    )
  end
end

function M.main()
  M.replace()
end

return M
