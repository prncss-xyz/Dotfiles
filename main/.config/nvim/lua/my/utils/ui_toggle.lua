local M = {}

M.conf = {
  keys = {},
}

local function to_list(v)
  if type(v) == 'table' then
    return v
  end
  return { v }
end

local function test_ft(ft, v)
  if v.ft == nil then
    return true
  end
  for _, test in ipairs(to_list(v.ft)) do
    if ft == test then
      return true
    end
  end
end

function M.key_from_win(win)
  local bufnr = vim.api.nvim_win_get_buf(win)
  local bt = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  if bt == '' then
    return
  end
  local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  for k, v in pairs(M.conf.keys) do
    if test_ft(ft, v) or test_ft(bt, v) or (v.cb and v.cb(win, bufnr, ft)) then
      return k
    end
  end
end

local function act(value)
  if type(value) == 'string' then
    vim.cmd(value)
  elseif type(value) == 'function' then
    value()
  end
end

local last_key
local last_keyed_win
local last_unkeyed_win, last_last_unkeyed_win

-- TODO: skip if already in focus
function M.raise()
  if last_key then
    local opts = M.conf.keys[last_key]
    local action = opts and opts.raise
    if action then
      M.activate(last_key, action)
    end
  else
    act(M.conf.default)
  end
end

function M.clear(keep_key)
  local empty = true
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local key = M.key_from_win(win)
    if key and (not keep_key or key ~= keep_key) then
      vim.api.nvim_win_close(win, false)
      empty = false
    end
  end
  if keep_key then
    last_key = keep_key
  end
  return empty
end

function M.prepare(key)
  M.clear(key)
end

function M.activate(key, action)
  action = action or M.conf.keys[key].raise
  M.clear(key)
  act(action)
end

function M.close(toggle)
  local empty = M.clear()
  if empty and toggle then
    M.raise()
  end
end

local function other(current, keyed)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= current and (keyed == (not not M.key_from_win(win))) then
      return win
    end
  end
  return nil
end

local function try_prospect(current, prospect)
  if
    prospect
    and prospect ~= current
    and vim.api.nvim_win_is_valid(prospect)
  then
    return prospect
  end
end

function M.setup(opts)
  M.conf = vim.tbl_extend('keep', opts, M.conf)
end

M.setup {
  default = 'Neotree',
  skip_buf = { 'terminal' },
  keys = {
    neo_tree = {
      ft = 'neo-tree',
      raise = 'Neotree source=last',
    },
    trouble = {
      ft = 'Trouble',
      raise = 'Trouble',
    },
    aerial = {
      ft = 'aerial',
      raise = 'AerialOpen',
    },
    tsplayground = {
      ft = { 'tsplayground', 'query' },
      raise = 'TSPlayground', -- InspectTree, EditQuery
    },
    toggleterm = {
      ft = 'toggleterm',
      raise = require('my.utils.terminal').toggle_non_float,
    },
    overseer = {
      ft = 'OverseerList',
      raise = 'OverseerOpen',
    },
    ----TODO: neotest
  },
}

--[[
  require('dapui').close()
  vim.cmd 'DapVirtualTextDisable'
  require('nvim-dap-virtual-text').disable()
  require('gitsigns').toggle_current_line_blame(true)
--]]
--
-- FIXME: Neotree then Trouble

return M
