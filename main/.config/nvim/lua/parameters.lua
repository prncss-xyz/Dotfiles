local M = {}

M.project_files = vim.env.HOME .. '/Media/Projects'
M.dotfiles = vim.env.DOTFILES or vim.fn.expand('~/.dotfiles', nil, nil)
M.pane_width = 55
M.vim_conf = vim.env.HOME .. '/.config/nvim'
M.prefer_single_quote = false
-- DEPRECATE
M.preferred_quote = '"'

return M
