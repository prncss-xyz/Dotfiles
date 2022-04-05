-- _G.Dump = require'modules.utils'.dump
_G.Dump = vim.inspect

require 'modules.edit_snippets'

require('modules.setup-session').setup {
  browser = require('modules.browser').open,
}
require('modules.theme-exporter').setup()
require('modules.buffet').setup()
require('modules.static_yank').setup()
