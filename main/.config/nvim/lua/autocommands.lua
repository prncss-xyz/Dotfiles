local augroup = require('utils').augroup
local dotfiles = os.getenv 'DOTFILES'

augroup('MakeExecutable', {
  {
    events = { 'BufWritePost' },
    targets = { dotfiles .. '*/.local/bin/*' },
    command = 'Chmod +x',
  },
})

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
-- create symlink when new dotfile is created in active package
-- NB: DOTFILES must NOT end with '/'
-- local dotfiles = os.getenv 'DOTFILES'
-- local packages = os.getenv 'STOW_ACTIVE_PACKAGES' or ''
-- for package in packages:gmatch '%S+' do
--   local pkgdir = dotfiles .. '/' .. package
--   local pattern = pkgdir .. '/*'
--   augroup('Dotfiles_' .. package, {
--     {
--       events = { 'BufWritePost' },
--       targets = { pattern },
--       command = function()
--         local src = vim.fn.expand '%:p'
--         local dst = vim.fn.expand '~' .. src:sub(#pkgdir + 1)
--         Job
--           :new({
--             command = 'ln',
--             args = { '-s', src, dst },
--           })
--           :start()
--       end,
--     },
--   })
-- end

-- not working
-- augroup('Illuminate', {
--   events = {'BufReadPost'},
--   targets = '*',
--   -- command = 'hi illuminatedWord cterm=underline gui=underline'
--   command = 'hi link illuminatedWord IncSearch'
-- })
-- vim.cmd[[
-- augroup illuminate_augroup
--     autocmd!
--     autocmd VimEnter * hi link illuminatedWord IncSearch
-- augroup END
-- ]]

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

-- augroup('NvimProjectConfig', {
--   {
--     events = { 'DirChanged' },
--     targets = { '*' },
--     command = require('nvim-projectconfig').load_project_config,
--   },
-- })
-- vim.cmd 'autocmd User LanguageToolCheckDone LanguageToolSummary'

-- vim.cmd "autocmd cursorhold,cursorholdi * lua require'nvim-lightbulb'.update_lightbulb()"

-- vim.cmd"au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}"
augroup('Autosave', {
  {
    events = { 'TabLeave', 'FocusLost', 'BufLeave' },
    targets = { '*' },
    modifiers = { 'silent!' },
    command = ':wa',
  },
})
