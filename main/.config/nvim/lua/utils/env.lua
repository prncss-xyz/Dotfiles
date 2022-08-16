local M = {}

local job = require('plenary').job

local confs
local prefix
local port

local function get_new_port()
  local port
  local file = io.open('/tmp/PORT', 'r')
  if file then
    port = tonumber(file:read '*a')
    file:close()
  else
    port = 3000
  end
  file = io.open('/tmp/PORT', 'w')
  if not file then
    return
  end
  file:write(tostring(port + 1))
  file:close()
  return port
end

function dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  if #objects == 0 then
    print 'nil'
  end
  print(unpack(objects))
  return ...
end

local function set_var(env, name, command, args)
  job
    :new({
      command = command,
      args = args,
      on_exit = function(j)
        env[name] = j:result()[1]
      end,
    })
    :sync()
end

local function set_var_from_pass(env, path)
  job
    :new({
      command = 'pass',
      args = { 'show', 'env/' .. path },
      on_exit = function(j)
        for _, row in ipairs(j:result()) do
          if row:sub(1, 1) ~= '#' then
            local col = string.find(row, '=', 1, true)
            if col then
              local name = row:sub(1, col - 1)
              local value = row:sub(col + 1)
              env[name] = value
            end
          end
        end
      end,
    })
    :sync()
end

local function apply_conf(env, conf)
  for name, value in pairs(conf) do
    if type(value) == 'table' then
      set_var(env, name, unpack(value))
    else
      env[name] = value
    end
  end
end

local function get_env(pwd)
  local env = {}
  if port then
    env.PORT = get_new_port()
  end
  for path, conf in pairs(confs) do
    if prefix .. path == pwd then
      set_var_from_pass(env, path)
      apply_conf(env, conf)
      break
    end
  end
  return env
end

local memo = {}

function M.get()
  local pwd = vim.env.PWD
  memo[pwd] = memo[pwd] or get_env(pwd)
  return memo[pwd]
end

function M.invalidate()
  local pwd = vim.env.PWD
  memo[pwd] = nil
end

function M.setup(t)
  t = t or {}
  prefix = t.prefix or ''
  confs = t.confs or {}
  port = t.port
end

return M
