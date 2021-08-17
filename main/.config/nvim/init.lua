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
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

require 'options'

vim.cmd 'cabbrev help tab help'
vim.cmd 'cabbrev h tab help'

_G.post_restore_cmds = {}
_G.pre_save_cmds = {}

require('signs').setup()

require 'plugins'
require 'signs'
require 'commands'
require 'autocommands'
require('theme').setup()
require 'theme-exporter'

if vim.fn.isdirectory(vim.o.directory) == 0 then
  vim.fn.mkdir(vim.o.directory, 'p')
end
