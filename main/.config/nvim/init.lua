pcall(function() -- needed to enable first installation
  require('impatient').enable_profile()
end)

local disabled_built_ins = {
  '2html_plugin',
  'filetypes', -- nathom/filetype.nvim
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'matchit',
  'netrw',
  'netrwFileHandlers',
  'netrwPlugin',
  'netrwSettings',
  'rrhelper',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

require('signs').setup()
require 'options'
require 'plugins'
require('bindings').setup()
require 'signs'
require 'commands'
require 'autocommands'
require('theme').setup()
require 'theme-exporter'
require 'setup-session'
