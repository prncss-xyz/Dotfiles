local M = {}

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

return M
