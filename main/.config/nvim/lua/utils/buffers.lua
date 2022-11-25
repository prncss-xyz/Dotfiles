local M = {}

function M.mv(source, target)
  local tsserver = require('utils.lsp').get_client 'tsserver'
  if tsserver then -- FIX:
    -- TODO: create needed directory
    -- TODO: test if path is directory
    vim.cmd 'TypescriptRenameFile'
    require('typescript').renameFile(
      vim.env.pwd + '/' + source,
      vim.env.pwd + '/' + target
    )
    vim.fn.delete(source)
  else
    vim.cmd { cmd = 'sav', args = { target } }
    vim.fn.delete(source)
  end
end

function M.rename()
  -- is there a more generic way to handle lsp move ?
  local default = vim.fn.expand '%:.'
  local tsserver = require('utils.lsp').get_client 'tsserver'
  local prompt = 'rename'
  if tsserver then
    prompt = prompt .. ' (tsserver)'
  end

  vim.ui.input({ prompt = prompt, default = default }, function(target)
    local source = vim.fn.expand '%:.'
    if target == nil or target == '' or target == source then
      return
    end
    M.mv(source, target)
  end)
end

function M.edit()
  local default = vim.fn.expand '%:.:h'
  if default == '.' then
    default = ''
  else
    default = default .. '/'
  end
  vim.ui.input({ prompt = 'edit', default = default }, function(dest)
    local source = vim.fn.expand '%:.'
    if dest == nil or dest == '' or dest == source then
      return
    end
    -- TODO: test if directory
    -- TODO: create needed directory
    vim.cmd { cmd = 'edit', args = { dest } }
  end)
end

function M.edit_newest()
  local res
  local Job = require('plenary').job
  Job:new({
    command = 'sh',
    -- --FIX: not working
    args = { '-c', 'sh -c "fd --maxdepth 1 --type file|sort -r|tail -1"' },
    cwd = os.getenv 'HOME',
    on_exit = function(j, _)
      res = j:result()
    end,
  }):sync()
  dump(res)
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
