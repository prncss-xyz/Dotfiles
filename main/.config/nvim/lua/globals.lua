function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  if #objects == 0 then
    print 'nil'
  end
  print(unpack(objects))
  return ...
end

function _G.vim_setup(o)
  for k, v in pairs(o) do
    for k2, v2 in pairs(v) do
      vim[k][k2] = v2
    end
  end
end

function _G.vim_g_setup(o)
  for k, v in pairs(o) do
    vim.g[k] = v
  end
end

function _G.my_title()
  local branch = vim.b.gitsigns_head
  local titlestring = ''
  local home = vim.loop.os_homedir()
  local dir = vim.fn.getcwd()
  if dir == home then
    dir = '~'
  else
    local _, i = dir:find(home .. '/', 1, true)
    if i then
      dir = dir:sub(i + 1)
    end
  end
  titlestring = titlestring .. dir
  if branch then
    titlestring = titlestring .. ' — ' .. branch
  end
  titlestring = titlestring .. ' — NVIM'
  return titlestring
end
