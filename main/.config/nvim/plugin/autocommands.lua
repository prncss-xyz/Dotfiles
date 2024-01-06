local group = vim.api.nvim_create_augroup('My', {})

-- Makes terminal aware of current directory
-- if not running from a GUI
if vim.fn.has 'gui' == 0 then
  vim.api.nvim_create_autocmd('DirChanged', {
    desc = 'update cwd in terminal',
    pattern = '*',
    group = group,
    callback = function()
      local uri = 'file://localhost/' .. vim.fn.getcwd()
      vim.fn.chansend(vim.v.stderr, '\x1B]7;' .. uri .. '\x1B\\')
    end,
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase', 'gitconfig', 'NeogitCommitMessage' },
  group = group,
  callback = function()
    vim.bo.bufhidden = 'delete'
  end,
})

if false then
  vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
    pattern = '*',
    group = group,
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(t)
    -- Function gets a table that contains match key, which maps to `<amatch>` (a full filepath).
    local dirname = vim.fs.dirname(t.match)
    -- Attempt to mkdir. If dir already exists, it returns nil.
    -- Use 755 permissions, which means rwxr.xr.x
    vim.loop.fs_mkdir(dirname, tonumber('0755', 8))
  end,
  group = group,
})

local pass_prefix = '/dev/shm/pass.'
if vim.fn.expand('%:h'):sub(1, pass_prefix:len()) == pass_prefix then
  vim.g.secret = true
else
  -- without this, deleted marks do not get removed on exit
  -- https://github.com/neovim/neovim/issues/4288
  vim.api.nvim_create_autocmd({
    'TabLeave',
    'FocusLost',
    'BufLeave',
    'VimLeavePre',
    'TextYankPost',
  }, {
    pattern = '*',
    group = group,
    callback = function()
      vim.cmd 'wshada'
    end,
  })
  vim.api.nvim_create_autocmd('FocusGained', {
    pattern = '*',
    group = group,
    callback = function()
      vim.cmd 'rshada'
    end,
  })
  vim.api.nvim_create_autocmd('CursorHold', {
    pattern = '*',
    group = group,
    callback = function()
      vim.cmd 'rshada|wshada'
    end,
  })
end

-- FIXME: is it working?
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
    vim.opt_local.undofile = false
  end,
  group = group,
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

if false then
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
    pattern = '*.md',
    group = group,
    callback = require('my.config.zk.utils').update_title,
  })
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    pattern = '*.md',
    group = group,
    callback = require('my.config.zk.utils').update_title_void,
  })
end

-- Without wrapping in an autocommand, you don't see the status line while telescope
-- the classical way of creating an augroup and clearing it does not seem to work, hence the `once` variable
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  group = group,
  callback = function()
    local args = vim.fn.argv()
    if #args > 0 then
      return
    end
    vim.schedule(function()
      fetch_git_branch_plenary()
      require('my.utils.open_project').open_project { cwd = vim.fn.getcwd() }
    end)
  end,
})
