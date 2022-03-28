local job_sync = require('modules.utils').job_sync
local pr = job_sync(vim.fn.expand '~/.local/bin/project_root', {})[1]
if pr then
  vim.cmd('cd ' .. pr)
end

local isHome = os.getenv 'HOME' == os.getenv 'PWD'

require('auto-session').setup {
  ('auto-session').setup {
  log_level = 'error',
  auto_save_enabled = true,
  auto_session_root_dir = os.getenv 'HOME' .. '/Media/sessions/',
  auto_restore_enabled = not isHome,
  post_restore_cmds = _G.post_restore_cmds,
  pre_save_cmds = _G.pre_save_cmds,
}

require('modules.utils').augroup('SessionAsk', {
  {
    events = { 'VimEnter' },
    targets = { '*' },
    modifiers = { 'silent!' },
        require('session-lens').search_session()
      if isHome then
        -- require('session-lens').search_session()
        -- require'telescope'.extensions.repo.list()
      end
    end,
  },
})
