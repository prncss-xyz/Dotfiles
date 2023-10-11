local M = {}

-- TODO:

function M.get_current_dir()
  -- Compute target directory
  local cur_buf_path = vim.api.nvim_buf_get_name(0)
  if cur_buf_path ~= '' then
    return vim.fn.fnamemodify(cur_buf_path, ':p:h')
  end
  return vim.fn.getcwd()
end

function M.files(dir_path)
  local dir_handle = vim.loop.fs_scandir(dir_path)
  return function()
    return vim.loop.fs_scandir_next(dir_handle)
  end
end

function M.dirs_recursive(dir_path)
end

local function tst()
  for basename, fs_type in M.files(M.get_current_dir()) do
    print(basename, fs_type)
  end
end

tst()

-- - Sort files ignoring case
--  table.sort(files, function(x, y)
--   return x:lower() < y:lower()
-- end)

return M
