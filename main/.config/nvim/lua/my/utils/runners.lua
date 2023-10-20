local M = {}

local config = {
  on_call_pre = function(wrapper)
    if wrapper == 'iron' then
      require('my.utils.ui_toggle').prepare(wrapper)
    end
  end,
  wrappers = {
    toggle_term = {
      ft = {
        'lua',
      },
      send_str = function(ft, str)
        local t = require 'my.utils.terminal'
        local key = t.get_key_by_ft(ft)
        if not key then
          error(string.format('no terminal for filetype %q', ft))
        end
        print 'send'
        t.send_str(key, str)
      end,
      raise = function(ft)
        local t = require 'my.utils.terminal'
        local key = t.get_key_by_ft(ft)
        if not key then
          error(string.format('no terminal for filetype %q', ft))
        end
        print 'raise'
        t.terminal(key)
      end,
    },
    iron = {
      ft = {
        'zsh',
        --[[ 'lua', ]]
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'go',
        'haskell',
      },
      send = function(ft, contents)
        require('iron.core').send(ft, contents)
        vim.cmd { cmd = 'IronFocus', args = { ft } }
      end,
      raise = function(ft)
        vim.cmd { cmd = 'IronFocus', args = { ft } }
      end,
      restart = function(ft)
        vim.cmd { cmd = 'IronRestart', args = { ft } }
      end,
    },
  },
}

---type string?
local current_ft

local function get_current_ft()
  local cursor = require('flies.utils.windows').get_cursor()
  return require('flies.utils.ts').get_vim_lang(0, { cursor, cursor })
end

local function call(method, ft, ...)
  if ft == nil then
    return
  end
  for wrapper, opts in pairs(config.wrappers) do
    if vim.tbl_contains(opts.ft, ft) then
      local cb = opts[method]
      if type(cb) == 'function' then
        current_ft = ft
        if config.on_call_pre then
          ---@diagnostic disable-next-line: redundant-parameter
          config.on_call_pre(wrapper, method, ft, ...)
        end
        return cb(ft, ...)
      end
      break
    end
  end
  error(string.format('method %q not available for filetype %q', method, ft))
end

function M.iron_raise()
  if not current_ft then
    return
  end
  call('raise', current_ft)
end

function M.focus()
  current_ft = get_current_ft()
  call('raise', current_ft)
end

function M.send()
  require('flies.operations._with_contents')
    :new({
      cb = function(ft, contents)
        current_ft = ft
        call('send', current_ft, contents)
      end,
    })
    :call {}
end

function M.restart()
  current_ft = get_current_ft()
  call('restart', current_ft)
end

return M
