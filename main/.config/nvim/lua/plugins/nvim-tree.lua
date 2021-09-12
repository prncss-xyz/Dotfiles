local M = {}

M.setup = function()
  require('utils').deep_merge(vim.g, {
    nvim_tree_ignore = { '.git' },
    nvim_tree_gitignore = 1,
    nvim_tree_auto_open = 1,
    -- nvim_tree_auto_close = 1,
    nvim_tree_ignore_ft = {},
    -- nvim_tree_quit_on_open = 1,
    nvim_tree_follow = 1,
    nvim_tree_highlight_opened_files = 1,
    nvim_tree_system_open_command = 'opener',
    nvim_tree_disable_default_keybindings = 1,
  })
end

function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

M.config = function()
  local bindings = {}
  local cb = require('nvim-tree.config').nvim_tree_callback
  for key, value in pairs(require('bindings').plugins.nvim_tree) do
    table.insert(bindings, {
      key = key,
      cb = cb(value),
    })
  end
  vim.g.nvim_tree_bindings = bindings

  require('nvim-tree.events').on_file_created(function(ev)
    local fname = ev.fname
    -- makes relevant files executables
    if (fname:match '/%.local/bin/' or fname:match '^%.local/bin/') and not fname:match '%.local/bin/.+%.' then
      os.execute(string.format('chmod +x %q', fname))
    end
    -- when new file belongs to an active stow package, stow it
    local dots = os.getenv 'DOTFILES'
    if vim.fn.getcwd() == dots then
      local stow_package = fname:match('^(.-)/', #dots + 2)
      if
        file_exists(
          string.format('%s/.config/stow/active/%s', os.getenv 'HOME', stow_package)
        )
      then
        os.execute(string.format('stow %q', stow_package))
      end
    end
    vim.cmd(string.format('e %s', fname))
  end)
end

return M
