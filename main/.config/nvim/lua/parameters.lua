local M = {}

M.dotfiles = vim.env.DOTFILES or vim.fn.expand('~/.dotfiles', nil, nil)
M.pane_width = 55
M.vim_conf = vim.env.HOME .. '/.config/nvim'

return M
