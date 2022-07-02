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

vim.api.nvim_create_autocmd(
  { 'TabLeave', 'FocusLost', 'BufLeave', 'VimLeavePre' },
  {
    pattern = '?*', -- do not match buffers with no name
    group = group,
    nested = true, -- needed for next autocommand
    callback = function()
      if vim.bo.modifiable and vim.bo.modified then
        vim.cmd 'silent :w'
      end
    end,
  }
)

-- Autocommit zettelkasten on every write
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = vim.fn.getenv 'ZK_NOTEBOOK_DIR' .. '/*',
  group = group,
  callback = function()
    -- we cannot assume vim.getcwd is current buffer's directory
    local cwd = vim.fn.expand('%:p:h', nil, nil)
    local job = require('plenary').job
    vim.defer_fn(function()
      job
        :new({
          command = 'git',
          args = { 'add', '--all' },
          cwd = cwd,
          on_exit = function()
            job
              :new({
                command = 'git',
                args = { 'commit', '--allow-empty-message', '-m', '' },
                cwd = cwd,
              })
              :start()
          end,
        })
        :start()
    end, 0)
  end,
})

local prefix = '/dev/shm/pass.'
if vim.fn.expand('%:h', nil, nil):sub(1, prefix:len()) == prefix then
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

-- TODO: command to open in right directory
local function fish_pet()
  local filename = vim.fn.expand('%', nil, nil)
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
    -- vim.defer_fn(function()
    --   require('telescope').extensions.luasnip.luasnip {}
    -- end, 10)
  end
end

-- Without wrapping in an autocommand, you don't see the status line while telescope
-- the classical way of creating an augroup and clearing it does not seem to work, hence the `once` variable
local once = true
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  group = group,
  callback = function()
    vim.schedule(function()
      if once then
        once = false
      else
        return
      end
      fetch_git_branch_plenary()
      local filename = vim.fn.expand('%', nil, nil)
      if string.find(filename, 'tmp%..+%.fish') then
        fish_pet()
      elseif #vim.fn.argv() > 0 then
      elseif vim.fn.getcwd() == os.getenv 'HOME' then
        require('telescope').extensions.my.projects {}
      else
        require('bufjump').backward()
        -- vim.cmd 'BufSurfBack'
        -- require('harpoon.ui').nav_file(1)
        -- require('utils.buffers').project_files()
      end
      -- TODO: force statusline refresh
    end)
  end,
})
