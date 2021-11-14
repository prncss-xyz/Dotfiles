local M = {}

local module = 'which-key-fallback'

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

M.register = M.register or fallback_register

M.store = {}
M.help = {}

local function create(f, help)
  table.insert(M.store, f)
  local id = #M.store
  M.help[id] = help
  return string.format('<cmd>lua require%q.store[%d]()<cr>', module, id)
end

local function reg2(t, bufnr, acc)
  if type(t) ~= 'table' then
    t = { t }
  end
  local rhs = t[1]
  if rhs then
    if type(rhs) == 'function' then
      rhs = create(rhs, t[2])
    end
    local map_opts = {
      silent = t.silent,
      noremap = t.noremap,
      expr = t.expr,
    }
    if map_opts.noremap == nil then
      map_opts.noremap = true
    end
    local modes = t.modes or acc.modes or 'n'
    for mode in string.gmatch(modes, '.') do
      -- TODO: map function
      -- print(mode, acc.keys, rhs)
      -- require('utils').dump(map_opts)
      if bufnr then
        vim.api.nvim_buf_set_keymap(bufnr, mode, acc.keys, rhs, map_opts)
      else
        vim.api.nvim_set_keymap(mode, acc.keys, rhs, map_opts)
      end
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
        reg2(v0, bufnr, acc0)
      end
    else
      local acc0 = vim.tbl_extend('error', {}, acc)
      acc0.keys = acc.keys .. k
      reg2(v, bufnr, acc0)
    end
  end
end

function M.reg2(t)
  reg2(t, nil, { keys = '' })
end

function M.reg2_local(t)
  local bufnr = vim.api.nvim_get_current_buf()
  reg2(t, bufnr, { keys = '' })
end

function M.reg(opts, t)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  local bufnr = options.buffer
  local modes = options.modes
  local map_opts = {
    noremap = options.noremap,
    expr = options.expr,
    silent = options.silent,
  }
  if not modes or modes == '' then
    error 'no modes'
    return
  end
  for mode in string.gmatch(modes, '.') do
    for key, value in pairs(t) do
      local rhs = value[1]
      if rhs then
        if bufnr then
          vim.api.nvim_buf_set_keymap(bufnr, mode, key, rhs, map_opts)
        else
          vim.api.nvim_set_keymap(mode, key, rhs, map_opts)
        end
      else
        M.register(value, {
          mode = mode,
          prefix = key,
          noremap = options.noremap,
          expr = options.expr,
          silent = options.silent,
          buffer = bufnr,
        })
      end
    end
  end
end

return M
