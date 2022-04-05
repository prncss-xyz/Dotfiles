local utils = require 'modules.utils'
local command = utils.command

-- TODO: combine the two into a vararg with command line completion

command('EditSnippets', {}, function()
  local l = vim.bo.filetype
  if l == '' then
    return
  end
  if l == 'javascript' then
    l = 'javascript/javascript'
  elseif l == 'javascriptreact' then
    l = 'javascript/react'
  elseif l == 'typescript' then
    l = 'javascript/typescript'
  elseif l == 'typescriptreact' then
    l = 'javascript/react-ts'
  end
  vim.cmd(
    string.format(
      ':edit %s/snippets/%s.json',
      utils.local_repo 'friendly-snippets',
      l
    )
  )
end)

command('EditSnippetsA', { nargs = 1 }, function(l)
  if l == 'js' then
    l = 'javascript'
  elseif l == 'ts' then
    l = 'typescript'
  elseif l == 'jsx' then
    l = 'javascriptreact'
  elseif l == 'tsx' then
    l = 'typescriptreact'
  end
  if l == 'javascript' then
    l = 'javascript/javascript'
  elseif l == 'javascriptreact' then
    l = 'javascript/react'
  elseif l == 'typescript' then
    l = 'javascript/typescript'
  elseif l == 'typescriptreact' then
    l = 'javascript/react-ts'
  end
  vim.cmd(
    string.format(
      ':edit %s/snippets/%s.json',
      utils.local_repo 'friendly-snippets',
      l
    )
  )
end)
