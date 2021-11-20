local M = {}

local get_visual_selection = require('utils').get_visual_selection
local browser = os.getenv 'BROWSER'

function M.open(url)
  require('plenary.job')
    :new({
      command = browser,
      args = { '--new-window', url },
    })
    :start()
end

function M.search_cword(base)
  local word = vim.fn.expand '<cword>'
  local qs = require('utils').encode_uri(word)
  M.open(base .. qs)
end

function M.open_file()
  local word = vim.fn.expand '<cfile>'
  if word:match '^[^/]+/[^/]+$' then
    word = 'www.github.com/' .. word
  end
  M.open(word)
end

function M.search_visual(base)
  get_visual_selection(function(word)
    local qs = require('utils').encode_uri(word)
    M.open(base .. qs)
  end)
end

function M.man()
  local file = require('io').open('/tmp/sway-mega-hotkeys', 'a')
  file:write 'next browser'
  file:close()
  local word = vim.fn.expand '<cword>'
  require('plenary.job')
    :new({
      command = 'man',
      args = { '-h', word },
    })
    :start()
end

return M
