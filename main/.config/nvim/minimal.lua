-- nvim -u ~/.config/nvim/minimal.lua

-- https://github.com/mrjones2014/legendary.nvim/discussions/93
vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.cmd [[set packpath=/tmp/nvim/site]]
local package_root = '/tmp/nvim/site/pack'
local install_path = package_root .. '/packer/start/packer.nvim'
local function load_plugins()
  require('packer').startup {
    {
      'wbthomason/packer.nvim',
      -- ADD PLUGINS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
      {
        'rafcamlet/tabline-framework.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
      },
    },
    config = {
      package_root = package_root,
      compile_path = install_path .. '/plugin/packer_compiled.lua',
      display = { non_interactive = true },
    },
  }
end
_G.load_config = function()
  -- ADD INIT.LUA SETTINGS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
  local render = function(f)
    -- f.add { '...............' }
  end

  require('tabline_framework').setup { render = render }
end
if vim.fn.isdirectory(install_path) == 0 then
  print 'Installing plugins.'
  vim.fn.system {
    'git',
    'clone',
    '--depth=1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
end
load_plugins()
require('packer').sync()
vim.cmd [[autocmd User PackerComplete ++once echo "Ready!" | lua load_config()]]
