local m = {}

local browser = os.getenv 'BROWSER'
local scheme = { type = 'unknown' }
local first = true

local function setup(port, command)
  local dirname
  local job = require 'plenary.job'
  job
    :new({
      command = 'realpath',
      args = { '--relative-base', os.getenv 'PROJECTS', vim.fn.getcwd() },
      on_exit = function(j)
        dirname = j:result()[1]
      end,
    })
    :sync()
  local fifo = string.format('/tmp/session-%d', port)
  job:new({ command = 'mkfifo', args = { fifo } }):sync()
  os.execute(string.format ([[
    export PORT=%q
    pass show %q|. 2>/dev/null
    exec %q -e sh %q&
  ]], port, 'session/' .. dirname, os.getenv'TERMINAL', fifo ))
  local file = io.open(fifo, 'a')
  file:write(command)
  file:close()
end

local function get_new_port()
  local file = io.open('/tmp/PORT', 'r')
  local ctn = file:read("*a")
  file:close()
  local port = ctn and tonumber(ctn) or 3000
  file = io.open('/tmp/PORT', 'w')
  file:write(tostring(port+1))
  file:close()
  return port
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
        scheme.develop = 'gatsby develop'
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
  if scheme.port then
    require('plenary.job')
      :new({
        command = browser,
        args = { string.format('http://localhost:%d', scheme.port) },
      })
      :start()
  end
end

function m.develop()
  -- if scheme.develop then
  --   require('plenary.job')
  --     :new({
  --       command = 'setup-session',
  --       args = { scheme.port, scheme.develop },
  --     })
  --     :start()
  -- end
  setup(scheme.port, scheme.develop)
  if first then
    first = false
    m.launch()
  end
end

require('utils').command('SetupSessionInfo', {}, function()
  print(Dump(scheme))
end)

return m
