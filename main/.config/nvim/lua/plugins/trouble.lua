require('trouble').setup {
  position = 'left',
  width = 35,
  -- position = 'bottom',
  use_diagnostic_signs = true,
  action_keys = require('bindings').plugins.trouble,
}
