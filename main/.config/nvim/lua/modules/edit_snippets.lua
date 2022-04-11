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

command('EditLSSnippetsAll', {}, function()
  vim.cmd(
    string.format(
      ':edit %s%s%s.lua',
      vim.fn.getenv 'DOTFILES',
      '/main/.config/nvim/lua/snippets/luasnip/',
      'all'
    )
  )
end)

command('EditTMSnippets', {}, function()
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

command('EditTMSnippetsAll', {}, function()
  vim.cmd(
    string.format(
      ':edit %s%s%s.json',
      vim.fn.getenv 'DOTFILES',
      '/main/.config/nvim/lua/snippets/textmate/',
      'all'
    )
  )
end)
