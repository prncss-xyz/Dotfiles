local M = {}

local get_selection = require('my.utils.vim').get_selection

local browser = os.getenv 'BROWSER'

function M.browse(url)
  require('plenary').job
      :new({
        command = browser,
        args = { '--new-window', url },
      })
      :start()
end

function M.browse_dev()
  require('plenary').job
      :new({
        command = 'browse_dev',
        pwd = vim.fn.getenv 'PWD',
      })
      :start()
end

function M.search_cword(base)
  local word = vim.fn.expand('<cword>', nil, nil)
  local qs = require('my.utils.std').encode_uri(word)
  M.browse(base .. qs)
end

function M.search_visual(base)
  local word = table.concat(get_selection(), ' ')
  local qs = require('my.utils.std').encode_uri(word)
  M.browse(base .. qs)
end

function M.browse_cfile()
  local word = vim.fn.expand '<cfile>'
  if word:match '^[^/]+/[^/]+$' then
    word = 'www.github.com/' .. word
  end
  M.browse(word)
end

function M.man()
  -- local file = require('io').open('/tmp/sway-mega-hotkeys', 'a')
  -- file:write 'next browser'
  -- file:close()
  local word = vim.fn.expand '<cword>'
  require('plenary').job
      :new({
        command = 'man',
        args = { '-h', word },
      })
      :start()
end

return M
