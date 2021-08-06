local augroup = require('utils').augroup
local lint = require 'lint'

lint.linters_by_ft = {
  lua = { 'codespell' },
  -- markdown = { 'languagetool' },
}
augroup('Linters', {
  {
    events = { 'FileType' },
    targets = { '*' },
    command = function()
      if not lint.linters_by_ft[vim.bo.filetype] then
        return
      end
      augroup('Linter', {
        {
          events = { 'BufWritePost' },
          targets = { '<buffer>' },
          command = "silent! lua require'lint'.try_lint()",
        },
      })
    end,
  },
})
