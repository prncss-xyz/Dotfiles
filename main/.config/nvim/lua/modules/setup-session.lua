-- setup a developpement session, with pass integration
-- currently only gatsby is supported, but the system should be easy to reuse
--
-- launch a terminal
-- if a 'session/dirname' entry exists, is sourced in terminal's environment
-- exports a PORT value that is not in use on the localhost
-- launch a task determined by the working directory (currently, only gatsby is supported)
-- when tasks terminate, a notification is send and a shell session starts

local M = {}

local conf = {}
local scheme = { type = 'unknown' }

local function setup(port, command)
  local dirname
  local job = require('plenary').job
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
  job
    :new({
      command = os.getenv 'TERMINAL',
      args = {
        '--title=' .. dirname .. ' — ' .. command,
        '-e',
        'sh',
        fifo,
      },
    })
    :start()
  local file = io.open(fifo, 'a')
  file:write(string.format('export PORT=%q\n', port))
  file:write(string.format('source <(pass show %q)\n', scheme.pass))
  file:write(command .. '\n')
  file:write(
    string.format('notify-send %q\n', dirname .. ' — ' .. command .. ' done')
  )
  file:write(os.getenv 'SHELL' .. '\n')
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
  end
end

function M.launch()
  if scheme.port then
    conf.browser(string.format('http://localhost:%d', scheme.port))
  end
end

function M.develop()
  setup(scheme.port, scheme.develop)
end

function M.setup(conf0)
  conf = conf0
  vim.api.nvim_create_user_command('SetupSessionInfo', function()
    dump(scheme)
  end, { nargs = 0 })
  setup_scheme()
  vim.api.nvim_create_autocmd('DirChanged', {
    callback = setup_scheme,
  })
end

return M
