local M = {}

local templates

local function load_templates()
  templates = {}
  local ls = require 'luasnip'
  if not ls then
    return
  end
  for _, value in pairs(ls.snippets.TEMPLATES) do
    local glob = value.trigger
    value.trigger = ''
    local re_string = vim.fn.glob2regpat(glob)
    local re = vim.regex(re_string)
    table.insert(templates, {
      glob = glob,
      value = value,
      re = re,
    })
  end
end

-- picks the most specific match by the following startegy:
-- amongst all the matching patters, the most specific is the pattern that is
-- matched by every patter (patterns always match themselves)
local function match(filename)
  local res = {}
  for _, pattern in ipairs(templates) do
    local m = pattern.re:match_str(filename)
    if m then
      table.insert(res, pattern)
    end
  end
  if #res == 0 then
    return
  end
  for _, t1 in ipairs(res) do
    local m
    for _, t2 in ipairs(res) do
      m = t2.re:match_str(t1.glob)
      if not m then
        break
      end
    end
    if m then
      return t1
    end
  end
end

function M.template_match()
  local template = match(vim.fn.expand '%')
  if template then
    local snippet = (template.value):copy()
    snippet.trigger = ''
    snippet:trigger_expand(
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
    )
  end
end

load_templates()

require('utils').augroup('Templates', {
  {
    events = { 'BufNewFile' },
    targets = { '*' },
    command = 'lua require "templates".template_match()',
  },
})

return M
