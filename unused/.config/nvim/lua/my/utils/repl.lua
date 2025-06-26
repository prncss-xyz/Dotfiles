local M = {}

M.conf = {
  repl = {
    -- TODO: install tsx https://github.com/esbuild-kit/tsx
    sh = 'zsh',
    javascript = 'node',
    javascriptreact = 'node',
    typescript = 'node',
    typescriptreact = 'node',
    lua = 'lua',
    go = 'yaegi',
  },
}

local function get_current_ft()
  local cursor = require('flies.utils.windows').get_cursor()
  return require('flies.utils.editor').get_vim_lang(0, { cursor, cursor })
end

local function get_key_by_ft(ft)
  local key = M.conf.repl[ft]
  if not key then
    error(string.format('no terminal for filetype %q', ft))
  end
  return key
end

local function get_current_key()
  local ft = get_current_ft()
  if ft == '' then
    return
  end
  return get_key_by_ft(ft)
end

function M.focus()
  return require('my.utils.terminal').terminal(get_current_key())
end

function M.cr()
  return require('my.utils.terminal').cr(get_current_key())
end

function M.interrupt()
  return require('my.utils.terminal').interrupt(get_current_key())
end

function M.clear()
  return require('my.utils.terminal').clear(get_current_key())
end

function M.stop()
  return require('my.utils.terminal').stop(get_current_key())
end

function M.send()
  require('flies.operations._with_contents')
    :new({
      cb = function(ft, contents)
        local key = get_key_by_ft(ft)
        require('my.utils.terminal').send_lines(key, contents)
      end,
    })
    :call {}
end

return M
