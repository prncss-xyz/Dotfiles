pcall(require, 'impatient')

require 'options'
require 'modules'
require('bindings').setup()
require 'plugins'
require('modules.binder').setup_mappings()
require 'commands'
require 'autocommands'
require('theme').setup()

if vim.fn.getenv 'NVIM_EXPERIMENTS' == true then
  require 'experiments'
end

