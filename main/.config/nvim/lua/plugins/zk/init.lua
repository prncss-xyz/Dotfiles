local M = {}

function M.config()
  require('plugins.zk.utils').setup_autocommit()
  require('zk').setup {
    picker = 'telescope',
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
  require('plugins.zk.domains').setup()
end

return M
