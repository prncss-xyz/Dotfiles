local M = {}

function M.lazy(fn, ...)
  local args = { ... }
  return function()
    return fn(unpack(args))
  end
end

function M.lazy_req(module, fn_path, ...)
  local args = { ... }
  return function()
    local path = vim.split(fn_path, '.', { plain = true })
    local fn = require(module)
    for _, p in ipairs(path) do
      fn = fn[p]
    end
    return fn(unpack(args))
  end
end

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.keys(keys)
  vim.api.nvim_feedkeys(t(keys), 'n', true)
end

return M
