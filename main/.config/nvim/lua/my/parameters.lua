local M = {}

M.project_files = vim.env.HOME .. '/Projects'
M.dotfiles = vim.env.DOTFILES or vim.fn.expand '~/.dotfiles'
M.pane_width = 55
M.vim_conf = vim.env.HOME .. '/Dotfiles/main/.config/nvim'
M.preferred_quote = '"'

return M
