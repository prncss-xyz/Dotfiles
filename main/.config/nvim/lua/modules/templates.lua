local M = {}

-- https://github.com/neovim/neovim/blob/af82eab946cf9f36e544b0591b8c8c02e8ddf316/runtime/lua/vim/filetype.lua

local templates = {}

local function load_templates()
  local snips = require 'plugins.luasnip.templates'
  templates = {}
  local ls = require 'luasnip'
  if not ls then
    return
  end
  for _, value in pairs(snips) do
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

-- picks the most specific match by the following strategy:
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
    local snippet = template.value
    require('luasnip').snip_expand(snippet, {})
  end
end

function M.setup(_)
  load_templates()
  vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = '*',
    callback = function()
      require('modules.templates').template_match()
    end,
  })
end

return M
