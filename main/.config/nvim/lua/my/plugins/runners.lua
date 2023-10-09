return {
  {
    'Vigemus/iron.nvim',
    cmd = {
      'IronRepl',
      'IronRestart',
      'IronFocus',
      'IronHide',
    },
    config = function()
      -- not serializalbe
      require('iron.core').setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { 'zsh' },
            },
            lua = {
              command = { 'lua' },
            },
            javascript = {
              command = { 'node' },
            },
            javascriptreact = {
              command = { 'node' },
            },
            typescript = {
              command = { 'node' },
            },
            typescriptreact = {
              command = { 'node' },
            },
            go = {
              command = { 'yaegi' },
            },
            haskell = {
              command = function(meta)
                local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
                return require('haskell-tools').repl.mk_repl_cmd(file)
              end,
            },
          },
          repl_open_cmd = require('iron.view').right(100),
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      }
    end,
  },
  {
    'jbyuki/dash.nvim',
    cmd = { 'DashRun', 'DashConnect', 'DashDebug' },
  },
}
