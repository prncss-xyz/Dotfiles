local augroup = require('utils').augroup
local dotfiles = os.getenv 'DOTFILES'

augroup('TerminalNonumbers', {
  {
    events = { 'TermOpen' },
    targets = { '*' },
    command = function()
      print 'termopen'
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.cmd 'startinsert'
    end,
  },
})
-- augroup('TerminalEnter', {
--   {
--     events = { 'BufEnter' },
--     target = { '*' },
--     command = function()
--       if vim.bo.bt == 'terminal' then
--         vim.cmd 'startinsert'
--       end
--     end,
--   },
-- })
-- augroup('TmpFiles', {
--   {
--     events = { 'FileType' },
--     targets = { 'gitcommit', 'gitrebase', 'gitconfig' },
--     command = function()
--       vim.bo.bufhidden = 'delete'
--     end,
--   },
-- })

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
  -- local titlestring = ''
  -- local titlestring = 'nvim — '

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
    -- titlestring = titlestring .. ' ' .. branch .. ' — '
  end
  vim.cmd(string.format('let &titlestring=%q', titlestring))
end

local function set_title_plenary()
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

local function set_title_gitsigns()
  local branch = vim.b.gitsigns_head
  if branch then
    set_title(branch)
  else
    set_title_plenary()
  end
end

augroup('SetTitleGitsigns', {
  {
    events = { 'DirChanged', 'CursorHold' },
    targets = { '*' },
    command = set_title_gitsigns,
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

-- require'utils'.augroup('SessionAsk', {
--   {
--     events = { 'VimEnter' },
--     targets = { '*' },
--     modifiers = { 'silent!' },
--     command = function ()
-- require'persistence'.load()
-- vim.cmd("silent! BufferGoto %i<cr>")
-- require("persistence").load()
-- local isHome = os.getenv 'HOME' == os.getenv 'PWD'
-- if isHome then
--   -- require("persistence").load({last=true})
--   -- require('session-lens').search_session()
--   -- require'telescope'.extensions.repo.list()
-- else
--   require("persistence").load()
--   require'telescope' -- workaround
-- end
--     end,
--   },
-- })
