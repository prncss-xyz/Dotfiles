local cmd = vim.cmd
local indent = 2
vim.o.compatible = false
vim.o.syntax = 'on'
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
vim.o.mouse = 'a'
vim.o.swapfile = false
vim.o.backup = false
vim.o.updatetime = 500
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.completeopt = 'longest,menuone' --  "menuone,noselect"
vim.o.showmode = false
vim.o.guifont = 'Fira Code NerdFont'
vim.o.cursorline = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.hidden = true
--vim.o.clipboard = "unnamedplus"
vim.o.wildmode = 'full:list'
vim.o.wildignorecase = true
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.signcolumn = 'yes'
vim.o.wrap = true
vim.o.linebreak = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = '[[<Cmd>lua require("nvim_treesitter").foldexpr()<CR>]]'
vim.g.indentLine_char = '│'
vim.g.rg_command = 'rg --vimgrep -S'
vim.o.termguicolors = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
local format_options_prettier = {
  tabWidth = indent,
  singleQuote = true,
  trailingComma = 'all',
  configPrecedence = 'prefer-file',
}

vim.g.format_options_typescript = format_options_prettier
vim.g.format_options_javascript = format_options_prettier
vim.g.format_options_typescriptreact = format_options_prettier
vim.g.format_options_javascriptreact = format_options_prettier
vim.g.format_options_json = format_options_prettier
vim.g.format_options_css = format_options_prettier
vim.g.format_options_scss = format_options_prettier
vim.g.format_options_html = format_options_prettier
vim.g.format_options_yaml = format_options_prettier
vim.g.format_options_markdown = format_options_prettier

vim.g.languagetool_server_command = 'echo "Server Started"'
vim.g.languagetool = {
  markdown = { language = 'auto' },
}
-- see https://languagetool.org/http-api/swagger-ui/#!/default/post_check

vim.g.camelcasemotion_key = ','

require 'plugins'
require('theming').setup()
require('bindings').setup()
cmd('source ' .. vim.fn.stdpath 'config' .. '/autocommands.vim')
require 'setup/telescope'
require 'theme-exporter'
require 'setup/lsp'

vim.g.vista_icon_indent = { '╰─▸ ', '├─▸ ' }
vim.g['vista#renderer#enable_icon'] = 1
vim.g['vista#renderer#icons'] = {
  ['function'] = '',
  ['variable'] = '',
}

-- vim.g.indent_blankline_char_highlight_list = {"SpecialKey", "DevIconIni"}
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_buftype_exclude = { 'terminal' }

-- require "setup/specs" -- not working

require('treesitter-context.config').setup {
  enable = true,
}

vim.cmd 'set title'

require('nvim-projectconfig').load_project_config {
  project_dir = '~/Media/Projects/projects-config/',
}

function _G.Dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

require('auto-session').setup {
  log_level = 'error',
  -- auto_session_root_dir = "~/Personal/auto-session/",
  auto_save_enabled = true,
  auto_restore_enabled = true,
  -- post_restore_cmds = {"BufferLineSortByDirectory"},
}

require('session-lens').setup {
  shorten_path = false,
}

require('hlslens').setup {}
require 'setup/bufferline'
require('trouble').setup {}
require('nvim-lastplace').setup {
  lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
  lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
  lastplace_open_folds = true,
}
