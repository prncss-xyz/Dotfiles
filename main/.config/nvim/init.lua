pcall(require, 'impatient')

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

vim.cmd 'highlight link hl_ColorColumn Visual'
require 'options'
require('bindings').setup()
require 'plugins'
require('modules.binder').setup_mappings()
require 'modules'
require 'commands'
require 'autocommands'
require('theme').setup()

-- foot terminal
-- https://codeberg.org/dnkl/foot/wiki#user-content-how-to-configure-my-shell-to-emit-the-osc-7-escape-sequence
vim.cmd[[
autocmd InsertEnter * call chansend(v:stderr, "\e[?737769h")
autocmd InsertLeave * call chansend(v:stderr, "\e[?737769l")
set ttimeoutlen=0
]]
