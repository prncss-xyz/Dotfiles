local augroup = require('utils').augroup

-- Makes terminal aware of current directory
-- if nut running from a GUI
if vim.fn.has 'gui' == 0 then
  augroup('OSC7', {
    {
      events = { 'DirChanged' },
      targets = { '*' },
      command = function()
        local uri = 'file://localhost/' .. vim.fn.getcwd()
        vim.fn.chansend(vim.v.stderr, '\x1B]7;' .. uri .. '\x1B\\')
      end,
    },
  })
end

augroup('Templates', {
  {
    events = { 'BufNewFile' },
    targets = { '*' },
    command = function()
      require('modules.templates').template_match()
    end,
  },
})

augroup('TmpFiles', {
  {
    events = { 'FileType' },
    targets = { 'gitcommit', 'gitrebase', 'gitconfig' },
    command = function()
      vim.bo.bufhidden = 'delete'
    end,
  },
})

augroup('Autosave', {
  {
    events = { 'TabLeave', 'FocusLost', 'BufLeave', 'VimLeavePre' },
    targets = { '*' },
    modifiers = { 'silent!' },
    command = ':update',
  },
})

-- without this, deleted marks do not get removed on exit
-- https://github.com/neovim/neovim/issues/4288
augroup('SaveShada', {
  {
    events = { 'VimLeave' },
    targets = { '*' },
    command = 'wshada!',
  },
})

-- avoid keeping undo for temporary or confidential files
augroup('NoUndoFile', {
  {
    events = { 'BufWritePre' },
    targets = {
      '/dev/shm/pass.*',
      '/tmp/*',
      'COMMIT_EDITMSG',
      '*.tmp',
      '*.bak',
      '*~',
    },
    command = 'setlocal noundofile',
  },
})

local function set_title(branch)
  local titlestring = ''
  local home = vim.loop.os_homedir()
  local dir = vim.fn.getcwd()
  if dir == home then
    dir = '~'
  else
    local _, i = dir:find(home .. '/', 1, true)
    if i then
      dir = dir:sub(i + 1)
    end
  end
  titlestring = titlestring .. dir
  if branch then
    titlestring = titlestring .. ' — ' .. branch
  end
  titlestring = titlestring .. ' — NVIM'
  vim.cmd(string.format('let &titlestring=%q', titlestring))
end

local function set_title_git_plenary()
  local job = require 'plenary.job'
  local branch
  job
    :new({
      command = 'git',
      args = { 'branch', '--show-current' },
      cwd = os.getenv 'PWD',
      on_exit = function(j)
        branch = j:result()[1]
        vim.schedule(function()
          set_title(branch)
        end)
      end,
    })
    :start()
end

local function set_title_git()
  local branch = vim.b.gitsigns_head
  if branch then
    set_title(branch)
  else
    -- set_title_git_plenary()
  end
end

augroup('SetTitleGitsigns', {
  {
    events = { 'VimEnter', 'DirChanged', 'CursorHold' },
    targets = { '*' },
    command = set_title_git,
  },
})

-- TODO: make it work with BufRead or FileType
-- (having Telescope luasnip properly read filetype)
augroup('FishEditCmdline', {
  {
    events = { 'VimEnter' },
    targets = { 'tmp.*.fish' },
    -- events = { 'FileType' },
    -- targets = { 'fish' },
    command = function()
      if false then
        local filename = vim.fn.expand '%'
        if not string.find(filename, 'tmp%..+%.fish') then
          return
        end
      end
      vim.bo.filetype = 'fish'
      local buf = vim.api.nvim_buf_get_lines(0, 0, 1, false)
      -- launch telescope if buffer is empty
      if buf[1] == '' then
        vim.schedule(function()
          require('telescope').extensions.luasnip.luasnip {}
        end)
      end
    end,
  },
})

-- Without wrapping in an autocommand, you don't see the status line while telescope
augroup('StartupSession', {
  {
    events = { 'VimEnter' },
    targets = { '*' },
    command = function()
      vim.schedule(function()
        if #vim.fn.argv() > 0 then
          return
        end
        if vim.fn.getcwd() == os.getenv 'HOME' then
          require('telescope').extensions.my_projects.my_projects {}
        else
          -- TODO: open last file
        end
        set_title_git_plenary()
      end)
    end,
  },
})
