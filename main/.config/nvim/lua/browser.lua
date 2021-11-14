local m = {}

local browser = os.getenv 'BROWSER'

function m.open(url)
  require('plenary.job')
    :new({
      command = browser,
      args = { '--new-window', url },
    })
    :start()
end

function m.mapBrowserSearch(prefix, name, mappings)
  local register = require 'which-key-fallback'.register
  register { [prefix] = { name = name } }
  for abbr, value in pairs(mappings) do
    local url, help = unpack(value)
    register({
      [abbr] = {
        string.format('<cmd>lua require"browser".searchCword(%q)<cr>', url),
        help,
      },
    }, {
      prefix = prefix,
    })
    register({
      [abbr] = {
        string.format('"zy<cmd>lua require"browser".searchZ(%q)<cr>', url),
        help,
      },
    }, {
      prefix = prefix,
      mode = 'x',
    })
  end
end

function m.searchCword(base)
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

return m
