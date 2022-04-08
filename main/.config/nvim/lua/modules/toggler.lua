local M = {}

-- this module makes sure only one UI is opened at a time
-- this is a very simple system, without any kind of detection
-- therefore if UI is closed otherwise, system wont know, but it won't cause much problems either

-- call open(open, close) with respective commands or callbacks to open and close the UI
-- use back() to alternate with previously opened UI

local toggler = {}

local function exec(e)
  if type(e) == 'string' then
    vim.cmd(e)
  end
  if type(e) == 'function' then
    e()
  end
end

function M.open(open, close)
  if toggler.opened and toggler.current and toggler.current.close ~= close then
    exec(toggler.current.close)
  end
  toggler.last = toggler.current
  toggler.current = { open = open, close = close }
  toggler.opened = true
  exec(open)
end

function M.cb(open, close)
  return function()
    M.open(open, close)
  end
end


function M.show()
  if toggler.current then
    toggler.opened = true
    exec(toggler.current.open)
  end
end

function M.hide()
  if not toggler.opened then
    return
  end
  if toggler.current then
    toggler.opened = false
    exec(toggler.current.close)
  end
end

function M.toggle()
  if toggler.opened then
    toggler.opened = false
    return exec(toggler.current.close)
  end
  toggler.opened = true
  exec(toggler.current.open)
end

function M.back()
  require('utils').dump(toggler)
  if not toggler.opened then
    return M.show()
  end
  if toggler.last then
    M.open(toggler.last.open, toggler.last.close)
  end
end

return M
