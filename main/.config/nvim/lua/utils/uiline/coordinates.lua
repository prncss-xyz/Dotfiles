local no_num_list = {
  'NvimTree',
  'Outline',
  'Trouble',
  'DiffviewFiles',
  'Outline',
  'Trouble',
  'LuaTree',
  'dbui',
  'help',
  'dapui_scopes',
  'dapui_breakpoints',
  'dapui_stacks',
  'dapui_watches',
  'dap-repl',
  'dap-scopes',
}

local function coordinates()
  if vim.tbl_contains(no_num_list, vim.bo.filetype) then
    return ''
  end
  if vim.fn.expand '%' == '' then
    return ''
  end
  local line = vim.fn.line '.'
  local column = vim.fn.col '.'
  local line_count = vim.fn.line '$'
  return string.format(' %3d:%02d %d ', line, column, line_count)
end

return coordinates
