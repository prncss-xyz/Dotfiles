local M = {}

function M.move()
  -- is there a move generic way to handle lsp move ?
  local default = vim.fn.expand '%:.'
  local tsserver = require('utils.lsp').is_client_current 'tsserver'
  local prompt = 'move'
  if tsserver then
    prompt = prompt .. ' (tsserver)'
  end

  vim.ui.input({ prompt = prompt, default = default }, function(target)
    local source = vim.fn.expand '%:.'
    if target == nil or target == '' or target == source then
      return
    end
    -- TODO: create needed directory
    -- TODO: test if directory
    if false and tsserver then -- FIX:
      vim.cmd 'TypescriptRenameFile'
      require('typescript').renameFile(source, target)
    else
      -- TODO: vim 0.8  use new API
      vim.cmd('sav ' .. target)
      vim.fn.delete(source)
    end
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
    -- TODO: vim 0.8  use new API
    -- TODO: test if directory
    -- TODO: create needed directory
    vim.cmd('edit ' .. dest)
  end)
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
  vim.cmd('e ' .. filename)
end

local alt_patterns = {
  { '(.+)%_spec(%.[%w%d]+)$', '%1%2' },
  { '(.+)%.test(%.[%w%d]+)$', '%1%2' },
  { '(.+)%.lua$', '%1_spec.lua' },
  { '(.+) %- extra%.md$', '%1.md' },
  { '(.+)%.md$', '%1 - extra.md' },
  { '(.+)(%.[%w%d]+)$', '%1.test%2' },
}

local function get_alt(file)
  for _, pattern in ipairs(alt_patterns) do
    if file:match(pattern[1]) then
      return file:gsub(pattern[1], pattern[2])
    end
  end
end

function M.edit_alt()
  local alt = get_alt(vim.fn.expand '%')
  if alt then
    vim.cmd('e ' .. alt)
  end
end

function M.project_files()
  local ok = pcall(require('telescope.builtin').git_files)
  if ok then
    return
  end
  require('telescope.builtin').find_files()
end

return M
