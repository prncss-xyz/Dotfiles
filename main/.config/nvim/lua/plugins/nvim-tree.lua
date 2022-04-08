local M = {}

M.setup = function()
  require('utils').deep_merge(vim.g, {
    nvim_tree_ignore_ft = {},
    -- nvim_tree_quit_on_open = 1,
    nvim_tree_highlight_opened_files = 1,
  })
end

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function setup_bindings(buf_id)
  local cb = require('nvim-tree.config').nvim_tree_callback
  -- FIXME:
  vim.api.nvim_buf_set_keymap(
    buf_id,
    'n',
    'q',
    'lua require("modules.toggler").toggle()',
    { noremap = true, silent = true, nowait = true }
  )
  for key, value in pairs(require('bindings').plugins.nvim_tree) do
    vim.api.nvim_buf_set_keymap(
      buf_id,
      'n',
      key,
      cb(value),
      { noremap = true, silent = true, nowait = true }
    )
  end
end

-- https://github.com/sindrets/dotfiles/blob/cafb333578a1ad482531ba5091c5171b32525d24/.config/nvim/lua/nvim-config/plugins/nvim-tree.lua#L67-L120
local function custom_setup()
  local buf_id = vim.api.nvim_get_current_buf()
  local ok, custom_setup_done = pcall(
    vim.api.nvim_buf_get_var,
    buf_id,
    'custom_setup_done'
  )

  if ok and custom_setup_done == 1 then
    return
  end

  vim.api.nvim_buf_set_var(buf_id, 'custom_setup_done', 1)
  setup_bindings(buf_id)
end

require('utils').augroup('NvimTreeConfig', {
  {
    events = { 'FileType' },
    targets = { 'NvimTree' },
    command = custom_setup,
  },
})

M.config = function()
  require('nvim-tree').setup {
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    }, -- https://github.com/ahmedkhalf/project.nvim
    nvim_tree_gitignore = true,
    nvim_tree_ignore = { '.git' },
    tree_follow = true,
    tree_disable_default_keybindings = true,
    show_hidden = true,
    view = { width = vim.g.u_pane_width },
  }
  require('nvim-tree.events').on_file_created(function(ev)
    local fname = ev.fname
    -- makes relevant files executables
    if
      (fname:match '/%.local/bin/' or fname:match '^%.local/bin/')
      and not fname:match '%.local/bin/.+%.'
    then
      os.execute(string.format('chmod +x %q', fname))
    end
    -- when new file belongs to an active stow package, stow it
    local dots = os.getenv 'DOTFILES'
    if vim.fn.getcwd() == dots then
      local stow_package = fname:match('^(.-)/', #dots + 2)
      if
        file_exists(
          string.format(
            '%s/.config/stow/active/%s',
            os.getenv 'HOME',
            stow_package
          )
        )
      then
        os.execute(string.format('stow %q', stow_package))
      end
    end
    vim.cmd(string.format('e %s', fname))
    require('modules.templates').template_match()
  end)
end

return M
