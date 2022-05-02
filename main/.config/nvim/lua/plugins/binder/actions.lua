local M = {}

local util = require 'plugins.binder.util'

function M.cmd_previous()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_prev_item()
  else
    util.keys('<up>')
  end
end

function M.cmd_next()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_next_item()
  else
    util.keys('<down>')
  end
end

M.s_tab = util.first_cb(
  util.lazy_req('plugins.cmp', 'utils.confirm'),
  util.lazy_req('luasnip', 'jump', -1),
  util.lazy_req('tabout', 'taboutBack')
  -- util.lazy_req('tabout', 'taboutBackMulti')
)

M.tab = util.first_cb(
  util.lazy_req('plugins.cmp', 'utils.confirm'),
  util.lazy_req('luasnip', 'jump', 1),
  util.lazy_req('tabout', 'tabout')
  -- util.lazy_req('tabout', 'taboutMulti')
)

local alt_patterns = {
  { '(.+)%_spec(%.[%w%d]+)$', '%1%2' },
  { '(.+)%.test(%.[%w%d]+)$', '%1%2' },
  { '(.+)%.lua$', '%1_spec.lua' },
  { '(.+)(%.[%w%d]+)$', '%1.test%2' },
}

local function get_alt(file)
  for _, pattern in ipairs(alt_patterns) do
    if file:match(pattern[1]) then
      return file:gsub(pattern[1], pattern[2])
    end
  end
end

function M.edit_alt()
  local alt = get_alt(vim.fn.expand '%')
  if alt then
    vim.cmd('e ' .. alt)
  end
end

function M.project_files()
  if vim.fn.getcwd() == os.getenv 'HOME' .. '/Personal/neuron' then
    require('nononotes').prompt('edit', false, 'all')
    return
  end
  local ok = pcall(require('telescope.builtin').git_files)
  if ok then
    return
  end
  require('telescope.builtin').find_files()
end

return M
