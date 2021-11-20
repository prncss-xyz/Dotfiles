pcall(function() -- needed to enable first installation
  require('impatient').enable_profile()
end)

local g = vim.g

-- this won't significantly improve startup time
-- it will still make the system simpler
local disabled_built_ins = {
  '2html_plugin',
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
  g['loaded_' .. plugin] = 1
end

-- this will (slightly) improve startup time,
-- and make configuration more readable
g.did_load_filetypes = 1 -- nathom/filetype.nvim

vim.cmd 'cmapclear'
vim.cmd 'imapclear'
vim.cmd 'omapclear'
vim.cmd 'vmapclear'
vim.cmd 'nmapclear'
require 'options'
require('bindings').setup()
require 'plugins'
require('binder').setup_mappings()
require 'commands'
require 'autocommands'
require('theme').setup()
require 'setup-session'

vim.cmd [[
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    " GuiFont Montserrat:8
endif
]]
