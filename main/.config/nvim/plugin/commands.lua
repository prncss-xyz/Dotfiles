require('utils').command('D', { nargs = 1 }, function(name)
  vim.cmd(string.format('lua dump(%s)', name))
end)

require('utils').command('R', { nargs = 1 }, function(name)
  vim.cmd 'update'
  vim.cmd 'source %'
  -- TODO: R if path
  -- TODO: PackerCompile if path
end)
