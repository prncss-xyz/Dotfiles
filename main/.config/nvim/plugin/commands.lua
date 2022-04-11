local command = require('utils').command

command('D', { nargs = 1 }, function(name)
  vim.cmd(string.format('lua dump(%s)', name))
end)

command('R', { nargs = 1 }, function(name)
  vim.cmd 'update'
  vim.cmd 'source %'
  -- TODO: R if path
  -- TODO: PackerCompile if path
end)

command('S', { nargs = 0 }, function()
  vim.cmd [[
    vsp
    wincmd h
    vertical resize 85
  ]]
end)
