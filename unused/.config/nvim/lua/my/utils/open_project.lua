local M = {}

function M.open_project_(opts)
  vim.cmd.lcd(opts.cwd)
  require('telescope').extensions.smart_open.smart_open {
    cwd_only = true,
    filename_first = false,
  }
end

function M.open_project(opts)
  local dirpath = opts.cwd
  if not vim.endswith(dirpath, '/') then
    dirpath = dirpath .. '/'
  end
  for _, file in ipairs(vim.v.oldfiles) do
    if vim.startswith(file, dirpath) and vim.fn.filereadable(file) == 1 then
      vim.cmd.edit(file)
      return
    end
  end
  if dirpath == vim.fn.getenv 'HOME' then
    require('telescope').extensions.repo.list {}
  else
    require('telescope.builtin').find_files {
      cwd = dirpath,
      find_command = {
        'rg',
        '--files',
        '--hidden',
        '-g',
        '!.git',
      },
    }
  end
end

return M
