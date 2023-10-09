local M = {}

local conf = {
  neo_tree = {
    test = 'neo-tree',
    close = 'NeoTreeClose',
    actions = {},
  },
  aerial = {
    test = 'aerial',
    close = 'AerialCLose',
    actions = {},
  },
  dap = {
    test = { 'dap-', 'dapui_' },
    close = function()
      require('dapui').close()
      vim.cmd 'DapVirtualTextDisable'
      require('nvim-dap-virtual-text').disable()
      -- require('gitsigns').toggle_current_line_blame(true)
    end,
    actions = {},
  },
  trouble = {
    test = 'Trouble',
    close = 'TroubleClose',
    actions = {},
  },
  spectre = nil,
  overseer = nil,
}

local function key_from_win(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
  for k, v in pairs(conf) do
    local tests
    local t = v.test
    if type(t) == 'table' then
      tests = t
    else
      tests = { t }
    end
    for _, test in ipairs(tests) do
      if vim.startswith(ft, test) then
        return k
      end
    end
  end
  vim.notify('unknown key for filetype ' .. ft)
end

local function act(value)
  if type(value) == 'string' then
    vim.cmd(value)
  elseif type(value) == 'function' then
    value()
  end
end

local old_key, old_action

function M.activate(key, action)
  local res = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local key_ = key_from_win(win)
    if key_ then
      res[key_] = true
    end
  end
  for key_ in pairs(res) do
    if key_ ~= key then
      act(conf[key_].close)
    end
  end
  vim.defer_fn(function()
    act(conf[key].actions[action])
  end, 0)
  old_key, old_action = key, action
end

function M.focus()
  M.activate(old_key, old_action)
end

return M
