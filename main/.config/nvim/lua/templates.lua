local augroup = require('utils').augroup
local command = require('utils').command

local M = {}

local templates

-- loads templates from specified directory
-- transforms filenames to globs to vim regex
-- makes a list of filenames, regex
local function load_templates(path)
  local res = {}
  local p = io.popen(string.format('cd %q; fd -H -t f', path))
  for filename in p:lines() do
    local glob = filename:gsub('STAR', '*')
    local re_string = vim.fn.glob2regpat(glob)
    local re = vim.regex(re_string)
    table.insert(res, {
      filename = filename,
      glob = glob,
      re = re,
      command = '0r ' .. path .. '/' .. filename,
    })
  end
  p:close()
  return res
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
      m = t2.re:match_str(t1.filename)
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
  templates = load_templates(opts.path)
  vim.cmd 'autocmd BufNewFile * TemplateMatch'
  -- autocommand
end

command('TemplateMatch', {}, function()
  local template = match(vim.fn.expand '%')
  if template then
    vim.cmd(template.command)
  end
end)

local function getAlt(file)
  local base, ext
  base, ext = file:match '(.+)%.test(%.[%w%d]+)$'
  if base then
    return base .. ext
  end
  base, ext = file:match '(.+)(%.[%w%d]+)$'
  if base then
    return base .. '.test' .. ext
  end
end

command('AltTest', {}, function()
  local alt = getAlt(vim.fn.expand '%')
  if alt then
    vim.cmd('e ' .. alt)
  end
end)

return M
