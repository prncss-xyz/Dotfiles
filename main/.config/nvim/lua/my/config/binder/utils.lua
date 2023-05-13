local M = {}

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
  local keys = '<plug>' .. name
  vim.api.nvim_feedkeys(M.t(keys), 'm', false)
end

function M.np_(t)
  local prev, next_ = t.prev, t.next
  return require('binder').keys {
    desc = t.desc,
    prev = require('binder').b { 'np', prev, next_, false },
    next = require('binder').b { 'np', prev, next_, true },
  }
end

function M.np(t)
  local prev, next_ = t.prev, t.next
  local fp = function()
    require('flies.operations.move_again').recompose2(prev, next_, false)
  end
  local fn = function()
    require('flies.operations.move_again').recompose2(prev, next_, true)
  end
  t.prev = require('binder').b { fp }
  t.next = require('binder').b { fn }
  return require('binder').keys(t)
end

return M
