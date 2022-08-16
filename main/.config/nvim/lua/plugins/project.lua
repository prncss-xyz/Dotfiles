local M = {}

function M.config()
  require('project_nvim').setup {
    detection_method = { 'lsp', 'pattern' },
  }
end

return M
