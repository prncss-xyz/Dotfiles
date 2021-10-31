local M = {}

function M.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end

function M.local_repo(name)
  return os.getenv 'PROJECTS' .. '/' .. name
end

function M.buf_map(modes, lhs, rhs, opts)
  local bufnr = vim.fn.bufnr()
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if modes == '' then
    vim.api.nvim_buf_set_keymap(bufnr, '', lhs, rhs, options)
    return
  end
  for mode in modes:gmatch '.' do
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
  end
end

function M.map(modes, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if modes == '' then
    vim.api.nvim_set_keymap('', lhs, rhs, options)
    return
  end
  for mode in modes:gmatch '.' do
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
end

M._store = {}

-- mostly taken from https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/globals.lua

---Check if a cmd is executable
---@param e string
---@return boolean
function M.executable(e)
  return vim.fn.executable(e) > 0
end

-- ?? vim.tbl_deep_extend instead ??
-- TODO merge arrays
function M.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      M.deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

function M.invert(table)
  local res = {}
  for key, value in pairs(table) do
    res[value] = key
  end
  return res
end

local store = {}

local function create(f)
  table.insert(store, f)
  return #store
end

function M._execute(id, args)
  store[id](args)
end

-- @Description create a nammed command
-- @Param  name string
-- @Param  opts {nargs, types}
-- @Param  rhs
function M.command(name, opts, rhs)
  local nargs = opts.nargs or 0
  local types = (opts.types and type(opts.types) == 'table')
      and table.concat(opts.types, ' ')
    or ''

  if type(rhs) == 'function' then
    local fn_id = create(rhs)
    rhs = string.format(
      "lua require'utils'._execute(%d%s)",
      fn_id,
      nargs > 0 and ', <f-args>' or ''
    )
  end

  vim.cmd(string.format('command! -nargs=%s %s %s %s', nargs, types, name, rhs))
end

---@class Autocmd
---@field events string[] list of autocommand events
---@field targets string[] list of autocommand patterns
---@field modifiers string[] e.g. nested, once
---@field command string | function

---Create an autocommand
---@param name string
---@param commands Autocmd[]
function M.augroup(name, commands)
  vim.cmd('augroup ' .. name)
  vim.cmd 'autocmd!'
  for _, c in ipairs(commands) do
    local command = c.command
    if type(command) == 'function' then
      local fn_id = create(command)
      command = string.format("lua require'utils'._execute(%s)", fn_id)
    end
    vim.cmd(
      string.format(
        'autocmd %s %s %s %s',
        table.concat(c.events, ','),
        table.concat(c.targets or {}, ','),
        table.concat(c.modifiers or {}, ' '),
        command
      )
    )
  end
  vim.cmd 'augroup END'
end

function M.lambda(cb)
  local fn_id = create(cb)
  return string.format("lua require'utils'._execute(%d)", fn_id)
end

function M.job_sync(command, args)
  local Job = require('plenary').job
  local res
  Job
    :new({
      command = command,
      args = args,
      on_exit = function(j)
        res = j:result(j)
      end,
    })
    :sync()
  return res
end

-- http://lua-users.org/wiki/StringRecipes
function M.encode_uri(str)
  if str then
    str = str:gsub('\n', '\r\n')
    str = str:gsub('([^%w %-%_%.%~])', function(c)
      return ('%%%02X'):format(string.byte(c))
    end)
    str = str:gsub(' ', '+')
  end
  return str
end

return M
