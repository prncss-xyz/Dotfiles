local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'matchit',
}
-- for _, plugin in pairs(disabled_built_ins) do
--   vim.g['loaded_' .. plugin] = 1
-- end

vim.cmd 'cabbrev help tab help'
vim.cmd 'cabbrev h tab help'

require 'options'
require 'plugins'

local utils = require 'utils'
local job_sync = utils.job_sync
vim.cmd 'set title'
require 'signs'
require 'commands'

if vim.fn.isdirectory(vim.o.directory) == 0 then
  vim.fn.mkdir(vim.o.directory, 'p')
end

local pr = job_sync(vim.fn.expand '~/.local/bin/project_root', {})[1]
if pr then
  vim.cmd('cd ' .. pr)
end

require('theming').setup()
require('bindings').setup()
require('signs').setup()
require 'theme-exporter'
require 'autocommands'
-- require('nvim-startup').setup()
