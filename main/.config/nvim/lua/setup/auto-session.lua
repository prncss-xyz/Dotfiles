local M = {}

-- make sure autosaving command is set afterwards
function M.setup()
  local isHome = (os.getenv 'HOME' == os.getenv 'PWD')
  require('auto-session').setup {
    log_level = 'error',
    auto_save_enabled = true,
    auto_session_root_dir = os.getenv 'HOME' .. '/Media/sessions/',
    auto_restore_enabled = not isHome,
    post_restore_cmds = {
      'BufferOrderByDirectory',
      'AutoSearchSession',
    },
    pre_save_cmds = {
      [[lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false); print('Closing window', win) end end]],
      'TSContextDisable',
      -- 'lua require("dapui").close()',
      'SymbolsOutlineClose',
      -- 'DiffviewClose',
    },
  }
end
return M
