local command = require('utils').command
-- TODO - try to use regex captures

local M = {}

local templates

local function load_templates()
  if templates then
    return
  end
  templates = {}
  for _, value in pairs(require('luasnip').snippets.TEMPLATES) do
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
  return templates
end

-- picks the most specific match by the following startegy:
-- amongst all the matching patters, the most specific is the pattern that is
-- matched by every patter (patterns always match themselves)
local function match(filename)
  load_templates()
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

function M.setup(opts)
  vim.cmd 'autocmd BufNewFile * TemplateMatch'
  -- autocommand
end

command('TemplateMatch', {}, function()
  local template = match(vim.fn.expand '%')
  if template then
    local snippet = (template.value):copy()
    snippet.trigger = ''
    snippet:trigger_expand(
      Luasnip_current_nodes[vim.api.nvim_get_current_buf()]
    )
  end
end)

local function alts(patterns, file)
  for _, pattern in ipairs(patterns) do
    if file:match(pattern[1]) then
      return file:gsub(pattern[1], pattern[2])
    end
  end
end

function M.setupAlts(rules)
  command('AltTest', {}, function()
    local alt = alts(rules, vim.fn.expand '%')
    if alt then
      vim.cmd('e ' .. alt)
    end
  end)
end

M.setupAlts {
  { '(.+)%.test(%.[%w%d]+)$', '%1%2' },
  { '(.+)(%.[%w%d]+)$', '%1.test%2' },
}

return M
