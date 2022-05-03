require 'modules.edit_snippets'

-- require('modules.templates').setup {}
require('modules.setup-session').setup {
  browser = require('modules.browser').open,
}
require('modules.theme-exporter').setup()
require('modules.static_yank').setup()
require('modules.highlight_yank').setup()
