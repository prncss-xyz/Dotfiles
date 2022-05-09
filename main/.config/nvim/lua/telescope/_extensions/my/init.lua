local telescope = require 'telescope'

local exports = {}

for _, name in ipairs {
  'installed_plugins',
  'md_help',
  'modules',
  'project_directory',
  'projects',
} do
  exports[name] = require('telescope._extensions.my.' .. name)
end

return telescope.register_extension {
  exports = exports,
}
