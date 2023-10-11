local M = {}

M.conf = {
  repl = {
    sh = 'zsh',
    javascript = 'node',
    javascriptreact = 'node',
    typescript = 'node',
    typescriptreact = 'node',
    lua = 'lua',
    go = 'yaegi',
  },
  default = { '1' },
}
-- haskell = {
-- command = function(meta)
-- local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
-- return require('haskell-tools').repl.mk_repl_cmd(file)
-- end,
-- },

local terminals = {}
local last_terminal

function M.on_open(terminal)
  last_terminal = terminal
end

function M.toggle()
  if last_terminal then
    last_terminal:toggle()
  elseif M.conf.default then
    M.terminal(unpack(M.conf.default))
  end
end

function M.terminal(key, cmd)
  local terminal = terminals[key]
  if not terminal then
    terminal = require('toggleterm.terminal').Terminal:new { cmd = cmd }
    terminals[key] = terminal
  end
  terminal:toggle()
end

function M.repl()
  local ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local repl = M.conf.repl[ft]
  if not repl then
    return
  end
  M.terminal(repl, repl)
end

return M
