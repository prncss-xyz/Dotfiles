local telescope = require 'telescope'

local exports = {}

for _, name in ipairs {
  'md_help',
  'installed_plugins',
  'modules',
  'project_directory',
  'projects',
  'uniduck'
} do
  exports[name] = require('telescope._extensions.my.' .. name)
end

return telescope.register_extension {
  exports = exports,
}
