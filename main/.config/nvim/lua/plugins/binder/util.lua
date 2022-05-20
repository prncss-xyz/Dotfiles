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

function M.np(t)
  local fp, fn = require('flies.move_again').recompose(t.prev, t.next)
  t.prev = require('binder').b { fp }
  t.next = require('binder').b { fn }
  return require('binder').keys(t)
end


function M.asterisk_z()
  M.plug '(asterisk-z*)'
  -- vim.fn.feedkeys(t '<plug>(asterisk-z*)')
  require('flies.objects.search').set_search(true)
  require('hlslens').start()
end

function M.asterisk_gz()
  M.plug '(asterisk_gz*)'
  require('flies.objects.search').set_search(true)
  require('hlslens').start()
end


local function plug(t)
  if type(t) == 'string' then
    t = { t }
  end
  t.noremap = false
  t[1] = '<plug>' .. t[1]
  return t
end
local count = 0

local function repeatable_cmd(rhs, opts)
  count = count + 1
  local map = string.format('(u-%i)', count)
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>' .. map,
    '<cmd>' .. rhs .. '<cr>',
    opts or {}
  )
  return replug(map)
end

return M
