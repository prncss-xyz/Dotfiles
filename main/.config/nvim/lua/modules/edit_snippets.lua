local utils = require 'utils'
local command = utils.command

-- TODO: combine the two into a vararg with command line completion

command('EditLSSnippets', {}, function()
  local l = vim.bo.filetype
  if l == '' then
    l = 'all'
  end
  vim.cmd(
    string.format(
      ':edit %s%s%s.lua',
      vim.fn.getenv 'DOTFILES',
      '/main/.config/nvim/lua/snippets/luasnip/',
      l
    )
  )
end)

command('EditLSSnippetsA', { nargs = 1 }, function(l)
  local l = vim.bo.filetype
  if l == '' then
    l = 'all'
  end
  vim.cmd(
    string.format(
      ':edit %s%s%s.lua',
      vim.fn.getenv 'DOTFILES',
      '/main/.config/nvim/lua/snippets/luasnip/',
      l
    )
  )
end)

command('EditTSSnippets', {}, function()
  local l = vim.bo.filetype
  if l == '' then
    l = 'all'
  end
  vim.cmd(
    string.format(
      ':edit %s%s%s.json',
      vim.fn.getenv 'DOTFILES',
      '/main/.config/nvim/lua/snippets/textmate/',
      l
    )
  )
end)

command('EditTSSnippetsA', { nargs = 1 }, function(l)
  local l = vim.bo.filetype
  if l == '' then
    l = 'all'
  end
  vim.cmd(
    string.format(
      ':edit %s%s%s.json',
      vim.fn.getenv 'DOTFILES',
      '/main/.config/nvim/lua/snippets/textmate/',
      l
    )
  )
end)
