local utils = require 'utils'
local command = require('utils').command
local dotfiles = os.getenv 'DOTFILES'

command('ExportTheme', { nargs = 1 }, function(name)
  require('theme-exporter').export_theme(name)
end)

command('LaunchOSV', {}, function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    require('osv').launch { type = 'server', host = '127.0.0.1', port = 30000 }
  end
end)

command('EditSnippet', {}, function()
  vim.cmd(
    string.format(
      ':edit %s/main/.config/nvim/textmate/%s.json',
      dotfiles,
      vim.bo.filetype
    )
  )
end)

command('NpmRun', { nargs = 1 }, function(task)
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = { '-e', 'fish', '-C', 'npm run ' .. task },
    })
    :start()
end)

command('Term', {}, function()
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = {},
    })
    :start()
end)

command('Reload', {}, function()
  vim.cmd [[
      update
      luafile %
    ]]
end)

local browser = os.getenv 'BROWSER'
command('BrowserSearchCword', { nargs = 1 }, function(base)
  local word = vim.fn.expand '<cword>'
  local qs = require('utils').encode_uri(word)
  local url = base .. qs
  require('plenary.job')
    :new({
      command = browser,
      args = { url },
    })
    :start()
end)

command('BrowserSearchZ', { nargs = 1 }, function(base)
  local word = vim.fn.getreg 'z'
  local qs = require('utils').encode_uri(word)
  local url = base .. qs
  require('plenary.job')
    :new({
      command = browser,
      args = { url },
    })
    :start()
end)

command('BrowserSearchGh', {}, function()
  local word = vim.fn.expand '<cWORD>'
  local qs = word:match '[%w%d-_.]+/[%w%d-_.]+'
  local url = 'https://github.com/' .. qs
  require('plenary.job')
    :new({
      command = browser,
      args = { url },
    })
    :start()
end)

command('BrowserMan', {}, function()
  local word = vim.fn.expand '<cword>'
  require('plenary.job')
    :new({
      command = 'hman',
      args = { word },
    })
    :start()
end)

command('OnlyBuffer', {}, function()
  local cur_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if cur_buf ~= buf then
      pcall(vim.cmd, 'bd ' .. buf)
    end
  end
end)

command('Conceal', {}, function()
  vim.cmd [[
syntax match True "true" conceal cchar=⊤
syntax match False "false" conceal cchar=⊥
      ]]
end)

local alt_patterns = {
  { '(.+)%.test(%.[%w%d]+)$', '%1%2' },
  { '(.+)(%.[%w%d]+)$', '%1.test%2' },
}

local function get_alt(file)
  for _, pattern in ipairs(alt_patterns) do
    if file:match(pattern[1]) then
      return file:gsub(pattern[1], pattern[2])
    end
  end
end

local function edit_alt()
  local alt = get_alt(vim.fn.expand '%')
  if alt then
    vim.cmd('e ' .. alt)
  end
end

command('EAlt', {}, edit_alt)

-- require 'telescope/md'
