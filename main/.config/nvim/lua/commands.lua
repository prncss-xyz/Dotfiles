function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  if #objects == 0 then
    print 'nil'
  end
  print(unpack(objects))
  return ...
end

require('utils').command('Dump', { nargs = 1 }, function(name)
  vim.cmd(string.format('lua dump(%s)', name))
end)
