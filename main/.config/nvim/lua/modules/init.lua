require 'modules.edit_snippets'

require('modules.setup-session').setup {
  browser = require('modules.browser').open,
}
require('modules.theme-exporter').setup()
require('modules.static_yank').setup()
