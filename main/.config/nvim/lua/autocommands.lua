local augroup = require('utils').augroup
local dotfiles = os.getenv 'DOTFILES'

-- TODO: make executable

--- automatically clear commandline messages after a few seconds delay
--- source: http//unix.stackexchange.com/a/613645
-- augroup('ClearCommandMessages', {
--   {
--     events = { 'CmdlineLeave', 'CmdlineChanged' },
--     targets = { ':' },
--     command = function()
--       vim.defer_fn(function()
--         if vim.fn.mode() == 'n' then
--           vim.cmd [[echon '']]
--         end
--       end, 10000)
--     end,
--   },
-- })

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
augroup('TerminalEnter', {
  {
    events = { 'BufEnter' },
    target = { '*' },
    command = function()
      if vim.bo.bt == 'terminal' then
        vim.cmd 'startinsert'
      end
    end,
  },
})
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
    command = 'Reload',
    -- command = 'PackerCompile',
    -- need to fix PackerCompile related bug
  },
})

-- vim.cmd 'autocmd User LanguageToolCheckDone LanguageToolSummary'

augroup('SessionAsk', {
  {
    events = { 'VimEnter' },
    targets = { '*' },
    modifiers = { 'silent!' },
    command = function () 
      if (os.getenv 'HOME' == os.getenv 'PWD') then
        require('session-lens').search_session()
        -- require'telescope'.extensions.repo.list()
      end
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

