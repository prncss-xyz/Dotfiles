local M = {}

function M.config()
  require('harpoon').setup {
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
  }
end

return M
