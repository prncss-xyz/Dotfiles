-- Makes terminal aware of current directory
-- if nut running from a GUI
if vim.fn.has 'gui' == 0 then
  vim.api.nvim_create_autocmd('DirChanged', {
    pattern = '*',
    callback = function()
      local uri = 'file://localhost/' .. vim.fn.getcwd()
      vim.fn.chansend(vim.v.stderr, '\x1B]7;' .. uri .. '\x1B\\')
    end,
    desc = 'update cwd in terminal',
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
  callback = function()
    vim.bo.bufhidden = 'delete'
  end,
})

for _, event in ipairs { 'TabLeave', 'FocusLost', 'BufLeave', 'VimLeavePre' } do
  vim.api.nvim_create_autocmd(event, {
    pattern = '*',
    callback = function()
      if vim.bo.buftype == '' then
        vim.cmd 'update'
      end
    end,
  })
end

-- without this, deleted marks do not get removed on exit
-- https://github.com/neovim/neovim/issues/4288
for _, event in ipairs {
  'TabLeave',
  'FocusLost',
  'BufLeave',
  'VimLeavePre',
  'FocusGained',
  'TextYankPost',
  'CursorHold',
} do
  vim.api.nvim_create_autocmd(event, {
    pattern = '*',
    callback = function()
      vim.cmd 'rshada'
      vim.cmd 'wshada'
    end,
  })
end

--
-- local dotfiles = os.getenv 'DOTFILES'
-- require('utils').augroup('PackerCompile', {
--     {
--     events = { 'BufWritePost' },
--       targets = { dotfiles .. '/main/.config/nvim/lua/plugins.lua' },
--     command = 'update luafile % | PackerCompile',
--   },
-- })

-- FIXME: is it working
-- avoid keeping undo for temporary or confidential files
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {
    '/dev/shm/pass.*',
    '/tmp/*',
    'COMMIT_EDITMSG',
    '*.tmp',
    '*.bak',
    '*~',
  },
  callback = function()
    -- vim.opt_local.undofile = false
    -- vim.cmd 'setlocal noundofile'
  end,
})

local function fetch_git_branch_plenary()
  local job = require('plenary').job
  job
    :new({
      command = 'git',
      args = { 'branch', '--show-current' },
      cwd = os.getenv 'PWD',
      on_exit = function(j)
        vim.b.gitsigns_head = j:result()[1]
      end,
    })
    :start()
end

-- FIXME:
local function fish_pet()
  local filename = vim.fn.expand '%'
  if not string.find(filename, 'tmp%..+%.fish') then
    return
  end
  -- launch telescope if buffer is empty
  local buf = vim.api.nvim_buf_get_lines(0, 0, 1, false)
  if buf[1] ~= '' then
    return
  end
  if buf[1] == '' then
    vim.bo.filetype = 'fish'
    require 'luasnip'
    vim.defer_fn(function()
      dump(vim.bo.filetype)
      print(package.loaded['luasnip'])
      require('telescope').extensions.luasnip.luasnip {}
    end, 10)
  end
end

-- Without wrapping in an autocommand, you don't see the status line while telescope
-- the classical way of creating an augroup and clearing it does not seem to work, hence the `once` variable
local once = true
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    vim.schedule(function()
      if once then
        once = false
      else
        return
      end
      if false then
        pcall(
          require('modules.toggler').open,
          require('modules.blank_pane').open,
          require('modules.blank_pane').close
        )
      end
      local filename = vim.fn.expand '%'
      if string.find(filename, 'tmp%..+%.fish') then
        fish_pet()
      elseif #vim.fn.argv() > 0 then
      elseif vim.fn.getcwd() == os.getenv 'HOME' then
        vim.schedule(function()
          require('telescope').extensions.my_projects.my_projects {}
        end)
      else
        require('bindutils').project_files()
      end
      fetch_git_branch_plenary()
      -- TODO: force statusline refresh
    end)
  end,
})
