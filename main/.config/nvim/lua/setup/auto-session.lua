local M = {}
-- make sure autosaving command is set afterwards
function M.setup()
  require('auto-session').setup {
    log_level = 'error',
    -- auto_session_root_dir = "~/Personal/auto-session/",
    auto_save_enabled = true,
    auto_session_root_dir = os.getenv 'HOME' .. '/Media/sessions/',
    auto_restore_enabled = true,
    post_restore_cmds = {
      'BufferOrderByDirectory',
      'AutoSearchSession',
    },
    pre_save_cmds = {
      'TSContextDisable',
      -- 'lua require("dapui").close()',
      'SymbolsOutlineClose',
      -- 'DiffviewClose',
    },
  }
end
return M
