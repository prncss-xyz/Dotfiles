local augroup = require('modules.utils').augroup
local dotfiles = os.getenv 'DOTFILES'

augroup('TmpFiles', {
  {
    events = { 'FileType' },
    targets = { 'gitcommit', 'gitrebase', 'gitconfig' },
    command = function()
      vim.bo.bufhidden = 'delete'
    end,
  },
})

augroup('PackerCompile', {
  {
    events = { 'BufWritePost' },
    targets = { dotfiles .. '/main/.config/nvim/lua/plugins.lua' },
    command = 'update luafile %',
    -- command = 'PackerCompile',
    -- need to fix PackerCompile related bug
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
  vim.cmd(string.format('let &titlestring=%q', titlestring))
end

-- keep cursor in place while yankink
local cursor
augroup('CursorGet', {
  {
    events = { 'VimEnter', 'CursorMoved' },
    targets = { '*' },
    command = function()
      cursor = vim.fn.getpos('.')
    end,
  },
})
augroup('CursorSet', {
  {
    events = { 'TextYankPost' },
    targets = { '*' },
    command = function()
     if vim.fn.eval('v:event').operator == 'y' then
        -- vim.fn.setpos('.', cursor)
      end
    end,
  },
})
-- for operators: https://vimways.org/2019/making-things-flow/

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
    set_title_git_plenary()
  end
end

-- works with kitty terminal
-- do not work with foot terminal
augroup('SetTitleGitsigns', {
  {
    events = { 'VimEnter', 'DirChanged', 'CursorHold' },
    targets = { '*' },
    command = set_title_git,
  },
})

augroup('Outline', {
  {
    events = { 'FileType' },
    targets = { 'Outline' },
    command = 'setlocal scl=no',
  },
})

-- augroup('SelectProject', {
--   {
--     events = { 'VimEnter' },
--     targets = { '*' },
--     command = function()
--       if os.getenv 'HOME' == os.getenv 'PWD' then
--         -- if vim.fn.getcwd() == vim.loop.os_homedir() then
--         vim.cmd 'Telescope projects'
--         -- require('telescope').extensions.repo.list()
--         -- set_title_gitsigns()
--       else
--         set_title_gitsigns()
--       end
--     end,
--   },
-- })

-- augroup('LastFile', {
--   {
--     events = {'VimEnter'},
--     targets = {'*'},
--     command = require('bufjump').local_backward,
--   }
-- })
