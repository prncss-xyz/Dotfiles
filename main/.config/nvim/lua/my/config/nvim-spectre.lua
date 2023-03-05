local M = {}

function M.config()
  require('spectre').setup {
    mapping = {
      ['run_replace'] = {
        map = ',R',
        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
        desc = 'replace all',
      },
    },
  }
end

return M
