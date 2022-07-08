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
    pattern = '*?', -- do not match buffers with no name
    group = group,
    callback = function()
      local fname = vim.fn.expand '%'
      if
        vim.bo.modifiable
        and (vim.bo.modified or vim.fn.filereadable(fname) == 0)
        and (vim.fn.isdirectory(fname) == 0)
      then
        vim.cmd 'silent :w!'
      end
    end,
  }
)

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

-- Without wrapping in an autocommand, you don't see the status line while telescope
-- the classical way of creating an augroup and clearing it does not seem to work, hence the `once` variable
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  group = group,
  callback = function()
    vim.schedule(function()
      fetch_git_branch_plenary()
      local filename = vim.fn.expand('%', nil, nil)
      if #vim.fn.argv() > 0 then
      elseif vim.fn.getcwd() == os.getenv 'HOME' then
        require('telescope').extensions.my.projects {}
      else
        local prefix = vim.fn.getcwd() .. '/'
        for _, file in ipairs(vim.v.oldfiles) do
          if
            vim.startswith(file, prefix) and vim.fn.filereadable(file) == 1
          then
            vim.cmd('edit ' .. file)
            return
          end
        end
        -- require('harpoon.ui').nav_file(1)
        -- require('utils.buffers').project_files()
      end
      -- TODO: force statusline refresh
    end)
  end,
})
