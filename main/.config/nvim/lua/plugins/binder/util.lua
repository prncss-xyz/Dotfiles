local M = {}

function M.repeatable(t)
  return require('binder').b(t)
end

function M.alt(str)
  return string.format('<a-%s>', str)
end

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

function M.first_cb(...)
  local args = { ... }
  return function()
    for _, cb in ipairs(args) do
      local r = cb()
      if r then
        return r
      end
    end
  end
end

function M.all_cb(...)
  local args = { ... }
  return function()
    for _, cb in ipairs(args) do
      cb()
    end
  end
end

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.keys(keys)
  vim.api.nvim_feedkeys(M.t(keys), 'n', true)
end

function M.normal(keys)
  vim.cmd('normal! ' .. keys)
end

function M.plug(name)
  local keys = '<Plug>' .. name
  vim.api.nvim_feedkeys(M.t(keys), 'm', true)
end

return M
