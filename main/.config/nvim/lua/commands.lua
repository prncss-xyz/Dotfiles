local Job = require 'plenary/job'
local utils = require 'utils'
local job_sync = utils.job_sync
local command = require('utils').command
local dotfiles = os.getenv 'DOTFILES'
command('ExportTheme', { nargs = 1 }, function(name)
  require('theme-exporter').export_theme(name)
end)
command('AutoSearchSession', {}, function()
  local pr = job_sync(vim.fn.expand '~/.local/bin/project_root', {})[1]
  if pr then
    vim.cmd('cd ' .. pr)
  end
  if not pr then
    vim.cmd 'SearchSession'
  end
end)
command('LaunchOSV', {}, function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    require('osv').launch { type = 'server', host = '127.0.0.1', port = 30000 }
  end
end)
command('CheatDetect', {}, function()
  vim.cmd('Cheat ' .. vim.bo.filetype .. ' ')
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
  Job
    :new({
      command = vim.env.TERMINAL,
      args = { '-e', 'fish', '-C', 'npm run ' .. task },
    })
    :start()
end)
command('PnpmInstall', { nargs = 1 }, function(name)
  vim.cmd('!pnpm i ' .. name)
end)
command('PnpmInstallDev', { nargs = 1 }, function(name)
  vim.cmd('!pnpm i -D ' .. name)
end)
-- TODO select with telescope
command('PnpmRemove', { nargs = 1 }, function(name)
  vim.cmd('!pnpm rm ' .. name)
end)
command('T', {}, function()
  Job
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
  Job
    :new({
      command = browser,
      args = { url },
    })
    :start()
end)
command('BrowserSearchZ', { nargs = 1 }, function(base)
  local word = vim.fn.getreg 'z'
  print(word)
  local qs = require('utils').encode_uri(word)
  local url = base .. qs
  Job
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
  Job
    :new({
      command = browser,
      args = { url },
    })
    :start()
end)
command('BrowserMan', {}, function()
  local word = vim.fn.expand '<cword>'
  Job
    :new({
      command = 'hman',
      args = { word },
    })
    :start()
end)

-- require 'telescope/md'
