local m = {}

function m.setup()
  require('project_nvim').setup {
    detection_methods = { 'lsp' },
  }
  -- require('telescope').load_extension 'projects'
end

return m
