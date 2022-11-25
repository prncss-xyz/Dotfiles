-- pcall(require, 'impatient')
-- require 'impatient'.enable_profile()

-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/init.lua
local ok, reload = pcall(require, 'plenary.reload')
_G.RELOAD = ok and reload.reload_module or function(...)
  return ...
end
function _G.R(name)
  RELOAD(name)
  return require(name)
end

R 'globals'
R 'options'
R 'signs'
R 'plugins'
