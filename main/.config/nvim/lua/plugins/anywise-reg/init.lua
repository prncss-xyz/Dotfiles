local bindings = require('bindings').plugins.anywise_reg
local ac = require 'modules.anywise_compat'
ac.setup(bindings.textobjects)
require('anywise_reg').setup {
  operators = {},
  -- operators = { 'y' },
  textobjects = bindings.textobjects,
  paste_keys = bindings.paste_keys,
  register_print_cmd = true,
}
for k, v in pairs(bindings.setmap) do
  ac.setmap(k, '"+', v)
end
