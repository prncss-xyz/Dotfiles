local m = {}

-- TODO lua realpath

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
  scheme.pass = 'session/' .. dirname
  local fifo = string.format('/tmp/session-%d', port)
  job:new({ command = 'mkfifo', args = { fifo } }):sync()
  os.execute(string.format(
    [[
    export PORT=%q
    pass show %q|. 2>/dev/null
    exec %q --title=%q -e sh %q&
  ]],
    port,
    scheme.pass,
    os.getenv 'TERMINAL',
    dirname .. ' — ' .. command,
    fifo
  ))
  local file = io.open(fifo, 'a')
  file:write(command .. '; sleep inf')
  file:close()
end

local function get_new_port()
  local port = 3000
  local file = io.open('/tmp/PORT', 'r')
  if file then
    port = tonumber(file:read '*a')
    file:close()
  end
  file = io.open('/tmp/PORT', 'w')
  file:write(tostring(port + 1))
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
        scheme.develop = 'npx gatsby develop'
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
    command = setup_scheme,
  },
})

function m.launch()
  if scheme.port then
    require('browser').open(string.format('http://localhost:%d', scheme.port))
  end
end

function m.develop()
  setup(scheme.port, scheme.develop)
  if first then
    first = false
    m.launch()
  end
end

require('utils').command('SetupSessionInfo', {}, function()
  print(require'utils'.dump(scheme))
end)

return m
