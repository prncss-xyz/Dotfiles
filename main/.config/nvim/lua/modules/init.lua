_G.Dump = require'modules.utils'.dump

require('modules.setup-session').setup {
  browser = require('modules.browser').open,
}
require('modules.theme-exporter').setup()
require('modules.buffet').setup()
