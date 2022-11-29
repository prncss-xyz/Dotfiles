local M = {}

-- TODO: ammend
function M.commit()
  vim.ui.input({ prompt = 'git commit' }, function(msg)
    if msg == nil then
      return
    end
    local cmd = { 'git', 'commit', '-m', msg }

    vim.notify(string.format('Commited', source, msg))
    local result = vim.fn.systemlist(cmd)
    if
      vim.v.shell_error ~= 0
      or (#result > 0 and vim.startswith(result[1], 'fatal:'))
    then
      vim.notify('ERROR: git commit' .. result, log_error)
    end
  end)
end

return M
