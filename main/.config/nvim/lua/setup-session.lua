local m = {}

local browser = os.getenv 'BROWSER'
local scheme = { type = 'unknown' }
local first = true

local function get_new_port()
  local res
  local job = require 'plenary.job'
  job
    :new({
      command = 'get-new-port',
      on_exit = function(j)
        res = tonumber(j:result()[1])
      end,
    })
    :sync()
  return res
end

local function setup_scheme()
  local file = io.open('package.json', 'r')
  if file ~= nil then
    local contents = file:read '*all'
    file:close()
    local package = vim.fn.json_decode(contents)
    if type(package.scripts) == 'table' then
      if package.scripts.start == 'gatsby develop' then
        scheme.type = 'gatsty'
        scheme.develop = { 'gatsby', 'develop' }
        scheme.port = get_new_port()
      end
    end
    return
  end
  return
end

require('utils').augroup('SetupSession', {
  {
    events = { 'DirChanged' },
    targets = { '*' },
    -- command = setup_scheme,
    command = function()
      setup_scheme()
    end,
  },
})

function m.launch()
  local job = require 'plenary.job'
  if scheme.port then
    -- launch browser
    job
      :new({
        command = browser,
        args = { string.format('http://localhost:$d', scheme.port) },
      })
      :start()
  end
end

function m.develop()
  -- launch command
  local job = require 'plenary.job'
  if scheme.develop then
    job
      :new({
        command = 'setup-session',
        args = scheme.develop,
        env = { PORT = scheme.port },
      })
      :start()
  end
  if first then
    first = false
    m.launch()
  end
end

return m
