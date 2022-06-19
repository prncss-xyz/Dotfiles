local M = {}

function M.config()
  require('aerial').setup {
    default_direction = 'left',
    min_width = require 'parameters'.pane_width,
    backends = {
      'treesitter',
      'lsp',
      'markdown',
    },
    filter_kind = false,
    -- filter_kind = {
    --   'Class',
    --   'Constructor',
    --   'Enum',
    --   'Function',
    --   'Interface',
    --   'Module',
    --   'Method',
    --   'Struct',
    -- },
      -- To see all available values, see :help SymbolKind
  }
end

return M
