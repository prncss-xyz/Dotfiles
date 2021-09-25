local m = {}

local browser = os.getenv 'BROWSER'

function m.open(url)
  local file = require('io').open('/tmp/sway-mega-hotkeys', 'a')
  file:write 'next browser'
  file:close()
  if url then
    require('plenary.job')
      :new({
        command = browser,
        args = { '--new-tab', url },
      })
      :start()
  end
end

function m.searchCword (base)
  local word = vim.fn.expand '<cword>'
  local qs = require('utils').encode_uri(word)
  m.open(base .. qs)
end

function m.openCfile()
  local word = vim.fn.expand '<cfile>'
  if word:match '^[^/]+/[^/]+$' then
    word = 'www.github.com/' .. word
  end
  m.open(word)
end

function m.searchZ(base)
  local word = vim.fn.getreg 'z'
  local qs = require('utils').encode_uri(word)
  m.open(base .. qs)
end

function m.man()
  m.open()
  local word = vim.fn.expand '<cword>'
  require('plenary.job')
    :new({
      command = 'man',
      args = { '-h', word },
    })
    :start()
end

return m
