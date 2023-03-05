local telescope = require 'telescope'



local exports = {}

for _, name in ipairs {
  'md_help',
  -- 'move',
  'installed_plugins',
  'node_modules',
  -- 'project_directory',
  -- 'projects',
  'uniduck',
  'zk_notes',
} do
  exports[name] = require('telescope._extensions.my.' .. name)
end

return telescope.register_extension {
  exports = exports,
}
