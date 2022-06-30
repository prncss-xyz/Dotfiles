local M = {}

function M.config()
  require('zk').setup {
    picker = 'my_telescope',
    lsp = {
      config = {
        cmd = { 'zk', 'lsp' },
        name = 'zk',
      },
    },
    auto_attach = {
      enabled = true,
      filetypes = { 'markdown' },
    },
  }
end

return M
