local M = {}

local util = require 'plugins.binder.util'

function M.cr()
  local row = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  if line:match '^%s*#!/%w' and vim.bo.filetype == '' then
    vim.cmd 'filetype detect'
  end
end

function M.menu_previous()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_prev_item()
  else
    util.keys '<up>'
  end
end

function M.menu_next()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_next_item()
  else
    util.keys '<down>'
  end
end

local function starts_with(full, prefix)
  if full:sub(1, prefix:len()) == prefix then
    return true
  end
end

local function get_playground_dir()
  local project_dir = vim.fn.getenv 'PROJECTS'
  if project_dir:sub(project_dir:len(), project_dir:len()) ~= '/' then
    project_dir = project_dir .. '/'
  end
  local cwd = vim.fn.getcwd()
  if not starts_with(cwd, project_dir) then
    return
  end
  local rel = cwd:sub(project_dir:len() + 1)
  local path = project_dir .. 'extra/' .. rel
  return path
end

function M.edit_playground_file()
  local ft = vim.bo.filetype
  if ft == '' then
    return
  end
  if ft == 'javascript' then
    ft = 'js'
  end
  if ft == 'typescript' then
    ft = 'ts'
  end
  if ft == 'javascriptreact' then
    ft = 'jsx'
  end
  if ft == 'typescriptreact' then
    ft = 'tsx'
  end
  local path = get_playground_dir()
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end
  local filename = path .. '/playground.' .. ft
  vim.cmd('e ' .. filename)
end

M.jump_previous = util.first_cb(
  function()
    print 'previous'
  end,
  util.lazy_req('luasnip', 'jump', -1),
  util.lazy_req('tabout', 'taboutBack')
  -- util.lazy_req('tabout', 'taboutBackMulti')
)

M.jump_next = util.first_cb(
  function()
    print 'next'
  end,
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

function M.stop_by_name(name)
  local client = require('plugins.lsp.utils').get_client(name)
  if not client then
    return
  end
  vim.lsp.stop_client(client, true)
end

-- From echasnovski/mini.nvim

--- Print Lua objects in command line
---
---@param ... any Any number of objects to be printed each on separate line.
function M.put(...)
  local objects = {}
  -- Not using `{...}` because it removes `nil` input
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))

  return ...
end

--- Print Lua objects in current buffer
---
---@param ... any Any number of objects to be printed each on separate line.
function M.put_text(...)
  local objects = {}
  -- Not using `{...}` because it removes `nil` input
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, '\n'), '\n')
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)

  return ...
end

--- Zoom in and out of a buffer, making it full screen in a floating window
---
--- This function is useful when working with multiple windows but temporarily
--- needing to zoom into one to see more of the code from that buffer. Call it
--- again (without arguments) to zoom out.
---
---@param buf_id number Buffer identifier (see |bufnr()|) to be zoomed.
---   Default: 0 for current.
---@param config table Optional config for window (as for |nvim_open_win()|).

-- Window identifier of current zoom (for `zoom()`)
local zoom_winid = nil

function M.zoom(buf_id, config)
  if zoom_winid and vim.api.nvim_win_is_valid(zoom_winid) then
    vim.api.nvim_win_close(zoom_winid, true)
    zoom_winid = nil
  else
    buf_id = buf_id or 0
    -- Currently very big `width` and `height` get truncated to maximum allowed
    local default_config = {
      relative = 'editor',
      row = 0,
      col = 0,
      width = 1000,
      height = 1000,
    }
    config = vim.tbl_deep_extend('force', default_config, config or {})
    zoom_winid = vim.api.nvim_open_win(buf_id, true, config)
    vim.cmd 'normal! zz'
  end
end

return M
