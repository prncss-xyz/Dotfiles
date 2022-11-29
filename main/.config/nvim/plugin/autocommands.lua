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

-- Adds '-' on next line when editing a list
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown' },
  group = group,
  callback = function()
    vim.cmd [[
      setlocal formatoptions+=r
      setlocal comments-=fb:- comments+=:-
    ]]
  end,
})

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
      if not vim.api.nvim_buf_is_valid(0) then
        return
      end
      if vim.bo.buftype ~= '' then
        return
      end
      if not vim.bo.modifiable then
        return
      end
      local fname = vim.api.nvim_buf_get_name(0)
      if vim.fn.isdirectory(fname) == 1 then
        return
      end
      if vim.fn.filereadable(fname) == 0 then
        return
      end
      if not vim.bo.modified then
        return
      end
      vim.cmd 'silent :w!'
    end,
  }
)

local pass_prefix = '/dev/shm/pass.'
if vim.fn.expand('%:h', nil, nil):sub(1, pass_prefix:len()) == pass_prefix then
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

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  pattern = '*.md',
  group = group,
  callback = require('plugins.zk.utils').update_title,
})

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*.md',
  group = group,
  callback = require('plugins.zk.utils').update_title_void,
})
-- Without wrapping in an autocommand, you don't see the status line while telescope
-- the classical way of creating an augroup and clearing it does not seem to work, hence the `once` variable
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  group = group,
  callback = function()
    vim.schedule(function()
      fetch_git_branch_plenary()
      if #vim.v.argv > 1 then
      elseif vim.fn.getcwd() == os.getenv 'HOME' then
        -- TODO: make safe on bootstraping
        -- FIX: mysterious A input
        require('telescope').extensions.repo.list {}
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
        require('telescope.builtin').find_files {
          find_command = {
            'rg',
            '--files',
            '--hidden',
            '-g',
            '!.git',
          },
        }
      end
      -- TODO: force statusline refresh
    end)
  end,
})
