local M = {}

function M.config()
  require('my.utils.zk').setup_autocommit()
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
  require('my.utils.zk.domains').setup()
end

return M
