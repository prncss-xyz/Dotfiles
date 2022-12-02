local M = {}

local log_error = vim.log.levels.ERROR

function M.commit(default)
  vim.ui.input({ prompt = 'git commit', default = default }, function(msg)
    if msg == nil then
      return
    end
    local cmd = { 'git', 'commit', '-m', msg }
    local result = vim.fn.systemlist(cmd)
    if
      vim.v.shell_error ~= 0
      or (#result > 0 and vim.startswith(result[1], 'fatal:'))
    then
      vim.notify('ERROR: git commit' .. table.concat(result, '\n'), log_error)
      return
    end
    vim.notify(string.format 'Commited')
  end)
end

function M.amend()
  local cmd = { 'git', 'show', '-s', '--format=%s' }

  local result = vim.fn.systemlist(cmd)
  if
    vim.v.shell_error ~= 0
    or (#result > 0 and vim.startswith(result[1], 'fatal:'))
  then
    vim.notify('ERROR: git show' .. table.concat(result, '\n'), log_error)
    return
  end
  M.commit(table.concat(result, '\n'))
end

return M
