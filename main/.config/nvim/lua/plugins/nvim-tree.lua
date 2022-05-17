local M = {}

local bindings = {
  a = 'create',
  d = 'remove',
  l = 'parent_node',
  L = 'dir_up',
  K = 'last_sibling',
  J = 'first_sibling',
  o = 'system_open',
  p = 'paste',
  r = 'rename',
  R = 'refresh',
  t = 'next_sibling',
  T = 'prev_sibling',
  v = 'next_git_item',
  V = 'prev_git_item',
  x = 'cut',
  yl = 'copy_name',
  yp = 'copy_path',
  ya = 'copy_absolute_path',
  yy = 'copy',
  [';'] = 'edit',
  ['.'] = 'toggle_ignored',
  ['h'] = 'toggle_help',
  ['<bs>'] = 'close_node',
  ['<tab>'] = 'preview',
  ['<s-c>'] = 'close_node',
  ['<c-r>'] = 'full_rename',
  ['<c-t>'] = 'tabnew',
  ['<c-x>'] = 'split',
}

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
  for key, value in pairs(bindings) do
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'NvimTree' },
  callback = custom_setup,
})

M.config = function()
  require('nvim-tree').setup {
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    git = {
      ignore = true,
    },
    view = { width = vim.g.u_pane_width, mappings = { custom_only = true } },
    filters = {
      custom = { '.git' },
    },
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
