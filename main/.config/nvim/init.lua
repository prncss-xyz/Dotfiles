local cmd = vim.cmd
local indent = 2
--cmd "filetype indent on"
--cmd "syntax enable"
vim.o.compatible = false
vim.o.syntax = "on"
vim.o.undofile = true
vim.o.tabstop = indent
vim.bo.tabstop = indent
vim.o.softtabstop = 0
vim.bo.softtabstop = 0
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.o.autowrite = true
vim.o.autowriteall = true
vim.o.cmdheight = 1
vim.o.autoread = true
vim.o.lazyredraw = true
vim.o.termguicolors = true
vim.o.shiftwidth = indent
vim.bo.shiftwidth = indent
vim.o.smarttab = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.g.autosave = 1
vim.o.incsearch = true
vim.o.mouse = "a"
vim.o.swapfile = false
vim.o.updatetime = 500
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.completeopt = "longest,menuone"
vim.o.showmode = false
vim.o.guifont = "Fira Code NerdFont"
vim.o.cursorline = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.hidden = true
vim.o.clipboard = "unnamedplus"
vim.o.wildmode = "longest:list"
vim.o.wildignorecase = true
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.wo.scrolloff = 5
vim.wo.sidescrolloff = 5
vim.o.wrap = true
vim.o.linebreak = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = '[[<Cmd>lua require("nvim_treesitter").foldexpr()<CR>]]'
vim.g.indentLine_char = "│"
require "plugins"
require "theming".setup()
require "bindings".setup()
cmd("source " .. vim.fn.stdpath("config") .. "/autocommands.vim")
require "setup/telescope"
--[[
" Let's save undo info!
if !isdirectory($HOME."/.local/nvim")
    call mkdir($HOME."/.local/nvim", "", 0770)
endif
if !isdirectory($HOME."/.local/nvim/undo-dir")
    call mkdir($HOME."/.local/nvim/undo-dir", "", 0700)
endif
--]]
--cmd('set undodir ~/.local/share/nvim/undo')
--"set verbosefile=~/.log/nvim/verbose.log
--"set verbose=15
