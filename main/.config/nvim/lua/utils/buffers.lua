local M = {}

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
  local alt = get_alt(vim.fn.expand('%', nil, nil))
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
