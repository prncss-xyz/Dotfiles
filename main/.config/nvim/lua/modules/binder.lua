local M = {}

-- TODO at the moment we register with whichkey plugin everytime
-- would be better to only do this once but not sure when to do this
-- https://github.com/AckslD/nvim-whichkey-setup.lua/blob/main/lua/whichkey_setup.lua
-- vim.fn['which_key#register'](raw_key, textmap)
-- raw_key = vim.fn.escape(raw_key, '\\')
-- vim.api.nvim_set_keymap(mode, key, ':<c-u> :WhichKey "'..raw_key..'"<CR>', {silent=true, noremap=true})

local module = 'modules.binder'

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

local function fallback_register0(t, mode, prefix)
  for key, value in pairs(t) do
    -- local desc = ''
    if key == 'name' then
      -- desc = desc .. prefix .. key .. ' -> +' .. value .. '\n'
    else
      if value[1] then
        -- print(prefix .. key, value[1], mode)
        require('utils').map(mode, prefix .. key, value[1])
        -- desc = desc .. prefix .. key .. ' -> ' .. value[2] .. '\n'
      else
        fallback_register0(value, mode, prefix .. key)
      end
    end
  end
end

local function fallback_register(t, opts)
  opts = opts or {}
  fallback_register0(t, opts.mode or '', opts.prefix or '')
end

pcall(function()
  M.register = require('which-key').register
end)

-- M.register = M.register or fallback_register

M.store = {}
M.help = {}

local function map(bufnr, mode, keys, rhs, map_opts)
  -- TODO: map function
  -- print(mode,keys, rhs)
  -- require('utils').dump(map_opts)
  if bufnr then
    vim.api.nvim_buf_set_keymap(bufnr, mode, keys, rhs, map_opts)
  else
    local raw_key = keys
    -- vim.fn['which_key#register'](raw_key, textmap)
    -- keys = vim.fn.escape(raw_key, '\\')
    -- vim.api.nvim_set_keymap(
    --   mode,
    --   keys,
    --   ':<c-u> :WhichKey "' .. raw_key .. '"<CR>',
    --   { silent = true, noremap = true }
    -- )
    vim.api.nvim_set_keymap(mode, keys, rhs, map_opts)
  end
end

local mappings = {}

local function map_defer(...)
  table.insert(mappings, { ... })
end

function M.setup_mappings()
  for _, mapping in ipairs(mappings) do
    map(unpack(mapping))
  end
end

local function create(f, help)
  table.insert(M.store, f)
  local id = #M.store
  M.help[id] = help
  -- return string.format('<cmd>lua require%q.store[%d]()<cr>', module, id)
  return id
end

local function map_str(id, mode, send_mode)
  local mode_str
  if send_mode then
    mode_str = string.format('%q', mode)
  else
    mode_str = ''
  end
  return string.format(
    '<cmd>lua require%q.store[%d](%s)<cr>',
    module,
    id,
    mode_str
  )
end

function M.fn_str(cb, help)
  local id = create(cb, help)
  return map_str(id, '', false)
end

function M.map(modes, keys, rhs, map_opts)
  if type(rhs) == 'function' then
    rhs = M.fn_str(rhs)
  end
  for mode in string.gmatch(modes, '.') do
    map(nil, mode, keys, rhs, map_opts)
  end
end

M.counters = {}

local function count(mode)
  M.counters[mode] = M.counters[mode] or 0
  M.counters[mode] = M.counters[mode] + 1
end

M.captures = {}
local captures = M.captures

local function add_path(t, path, value)
  for i, key in ipairs(path) do
    if i == #path then
      t[key] = value
      return
    else
      t[key] = t[key] or {}
      t = t[key]
      if type(t) ~= 'table' then
        error 'conflict with a nonkey value'
      end
    end
  end
end

local function capture(keys, c)
  local value = c.value
  if value then
    table.insert(c, keys)
  else
    value = keys
  end
  add_path(captures, c, value)
end

local function reg(t, bufnr, acc)
  -- print(acc.keys)
  if type(t) ~= 'table' then
    t = { t }
  end
  local rhs = t[1]
  if rhs then
    local id
    if type(rhs) == 'function' then
      id = create(rhs, t[2])
    end
    local map_opts = {
      silent = t.silent,
      noremap = t.noremap,
      nowait = t.nowait,
      expr = t.expr,
    }
    if map_opts.noremap == nil then
      map_opts.noremap = true
    end
    local modes = t.modes or acc.modes or 'n'
    for mode in string.gmatch(modes, '.') do
      count(mode)
      local rhs0 = id and map_str(id, mode, t.mode) or rhs
      map_defer(bufnr, mode, acc.keys, rhs0, map_opts)
    end
    return
  end
  for k, v in pairs(t) do
    if k == 'name' then
      -- TODO:
    elseif k == 'modes' then
      for k0, v0 in pairs(v) do
        local acc0 = vim.tbl_extend('error', {}, acc)
        acc0.modes = k0
        reg(v0, bufnr, acc0)
      end
    elseif k == 'capture' then
      capture(acc.keys, v)
    elseif k == 'captures' then
      for _, c in ipairs(v) do
        capture(acc.keys, c)
      end
    else
      local acc0 = vim.tbl_extend('error', {}, acc)
      acc0.keys = acc.keys .. k
      reg(v, bufnr, acc0)
    end
  end
end

function M.reg(t)
  reg(t, nil, { keys = '' })
end

function M.reg_local(t)
  local bufnr = vim.api.nvim_get_current_buf()
  reg(t, bufnr, { keys = '' })
end

return M
