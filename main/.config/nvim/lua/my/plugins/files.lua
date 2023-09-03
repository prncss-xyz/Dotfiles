return {
  {
    'willothy/flatten.nvim',
    config = true,
    -- or pass configuration with
    -- opts = {  }
    -- Ensure that it runs first to minimize delay when opening file from terminal
    --[[ lazy = false, ]]
    --[[ priority = 1001, ]]
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    config = require('my.config.neo-tree').config,
    cmd = { 'Neotree' },
    dependencies = { dir = require('my.utils').local_repo 'neo-tree-zk.nvim' },
  },
  {
    dir = require('my.utils').local_repo 'khutulun.nvim',
    -- 'chrisgrieser/nvim-genghis',
    opts = {
      mv = function(source, target)
        local tsserver = require('my.utils.lsp').get_client 'tsserver'
        if tsserver then
          require('typescript').renameFile(source, target)
        else
          return require('khutulun').default_mv(source, target)
        end
      end,
      bdelete = function()
        require('bufdelete').bufdelete(0, true)
      end,
    },
  },
  {
    'ethanholz/nvim-lastplace',
    event = 'BufReadPre',
    opts = {
      lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
      lastplace_ignore_filetype = {
        'gitcommit',
        'gitrebase',
        'svn',
        'hgcommit',
      },
    },
  },
  {
    -- FIXME:
    'notjedi/nvim-rooter.lua',
    event = 'BufReadPost',
  },
  {
    'ThePrimeagen/harpoon',
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
      projects = {
        ['$DOTFILES'] = {
          term = {
            cmds = {
              'ls',
            },
          },
        },
      },
    },
  },
  -- 
  {
    'famiu/bufdelete.nvim',
  },
  {

    dir = require('my.utils').local_repo 'templum.nvim',
    config = require('my.config.templum').config,
    event = 'VimEnter',
  },
}
