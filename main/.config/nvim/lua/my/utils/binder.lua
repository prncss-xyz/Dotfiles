local M = {}

function M.cmd(str)
  return '<cmd>' .. str .. '<cr>'
end

function M.cmd_partial(str)
  return '<cmd>' .. str .. '<cr>'
end

return M
