local M = {}

-- inspiration: https://github.com/LintaoAmons/scratch.nvim

local exts = {
  javascriptreact = 'jsx',
  typescriptreact = 'tsx',
  typescript = 'ts',
  javascript = 'js',
}

function M.open()
  local dirname = vim.env.HOME .. '/.cache/nvim/scratch'
  vim.fn.mkdir(dirname, 'p')
  local ft = require('flies.utils.editor').get_lang_at_cursor()
  local filename = dirname .. '/main.' .. (exts[ft] or ft)
  vim.cmd { cmd = 'edit', args = { filename } }
end

function M.select()
  local dirname = vim.env.HOME .. '/.cache/nvim/scratch'
  vim.fn.mkdir(dirname, 'p')
  require('telescope.builtin').find_files {
    prompt_title = 'files (local)',
    -- cannot serialize this:
    cwd = dirname,
    find_command = {
      'fd',
      '--hidden',
      '--type',
      'f',
      '--strip-cwd-prefix',
    },
  }
end

return M
