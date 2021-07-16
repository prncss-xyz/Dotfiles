local utils = require 'utils'
local job_sync = utils.job_sync
vim.cmd 'let loaded_netrwPlugin = 1' -- disable netrw
vim.cmd 'set title'
require 'signs'
require 'options'
require 'commands'

if vim.fn.isdirectory(vim.o.directory) == 0 then
  vim.fn.mkdir(vim.o.directory, 'p')
end

local pr = job_sync(vim.fn.expand '~/.local/bin/project_root', {})[1]
if pr then
  vim.cmd('cd ' .. pr)
end

require 'plugins'
require('theming').setup()
require('bindings').setup()
require('signs').setup()
require 'theme-exporter'
require 'autocommands'
