local M = {}

-- --FIX: not working
function M.edit_newest()
  local res
  local Job = require('plenary').job
  Job:new({
    command = 'sh',
    args = { '-c', 'sh -c "fd --maxdepth 1 --type file|sort -r|tail -1"' },
    cwd = os.getenv 'HOME',
    on_exit = function(j, _)
      res = j:result()
    end,
  }):sync()
  dump(res)
end

function M.reload()
  vim.cmd 'update'
  vim.cmd 'source %'
end

function M.edit_playground_file()
  local ft = vim.bo.filetype
  if ft == '' then
    return
  end
  if ft == 'javascript' then
    ft = 'js'
  end
  if ft == 'typescript' then
    ft = 'ts'
  end
  if ft == 'javascriptreact' then
    ft = 'jsx'
  end
  if ft == 'typescriptreact' then
    ft = 'tsx'
  end
  local path = '_my_'
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end
  local filename = path .. '/playground.' .. ft
  vim.cmd { cmd = 'edit', args = { filename } }
end

function M.project_files()
  local ok = pcall(require('telescope.builtin').git_files)
  if ok then
    return
  end
  require('telescope.builtin').find_files()
end

return M
