function _G.dump(...)
  print(vim.inspect(...))
end

local branches = {}
function _G.my_title()
  local dir = vim.fn.getcwd()
  local home = vim.env.HOME
  if dir == vim.env.ZK_NOTEBOOK_DIR then
    return 'ZK'
  end
  if dir == home then
    return 'NVIM'
  end
  local branch = vim.b.gitsigns_head
  local titlestring = ''
  local _, i = dir:find(home .. '/', 1, true)
  if i then
    dir = dir:sub(i + 1)
  end
  -- Some buffers are aasociated with a dir but not a branch: telescope, nvim-tree...
  -- We use the latest branch result for these
  if dir and not branch then
    branch = branches[dir]
  end
  if branch then
    titlestring = titlestring .. dir
    titlestring = titlestring .. ' — ' .. branch
    branches[dir] = branch
  end
  titlestring = titlestring .. ' — NVIM'
  return titlestring
end
