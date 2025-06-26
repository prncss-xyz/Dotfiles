local M = {}

M.project_files = vim.env.HOME .. '/Projects'
M.dotfiles = vim.env.HOME .. '/Dotfiles'
M.vim_conf = M.dotfiles .. '/main/.config/nvim'
M.pane_width = 55
M.preferred_quote = '"'

return M
