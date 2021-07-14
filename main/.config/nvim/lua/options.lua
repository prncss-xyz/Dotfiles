local indent = 2
-- vim.o.bufhidden = "wipe" -- testing
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
vim.o.backup = false
vim.o.updatetime = 500
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.completeopt = "menuone,noselect"
vim.o.showmode = false
vim.o.guifont = "Fira Code NerdFont"
vim.o.cursorline = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.hidden = true
vim.o.clipboard = "unnamedplus"
vim.o.wildmode = "full:list"
vim.o.wildignorecase = true
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.signcolumn = "yes"
vim.o.wrap = true
vim.o.linebreak = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = '[[<Cmd>lua require("nvim_treesitter").foldexpr()<CR>]]'
vim.g.indentLine_char = "│"
vim.g.rg_command = "rg --vimgrep -S"
vim.o.termguicolors = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.opt.secure = true -- Disable autocmd etc for project local vimrc files.
vim.opt.exrc = false -- Allow project local vimrc files example .nvimrc see :h exrc
vim.opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
vim.g.languagetool_server_command = 'echo "Server Started"'
vim.g.languagetool = {
	["."] = { language = "auto" },
}
-- see https://languagetool.org/http-api/swagger-ui/#!/default/post_check
vim.g.camelcasemotion_key = ","
vim.g["asterisk#keeppos"] = 1
vim.g.vista_icon_indent = { "╰─▸ ", "├─▸ " }
vim.g["vista#renderer#enable_icon"] = 1
vim.g["vista#renderer#icons"] = {
	["function"] = "",
	["variable"] = "",
}
-- vim.g.indent_blankline_char_highlight_list = {"SpecialKey", "DevIconIni"}
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_buftype_exclude = { "terminal", "help" }
vim.g.limelight_paragraph_span = 5
vim.env.GIT_EDITOR = "nvr"
vim.env.EDITOR = "nvr"
vim.o.grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]]
vim.g.markdown_fenced_languages = {
	"js=javascript",
	"ts=typescript",
	"shell=sh",
	"sh=sh",
	"bash=sh",
	"console=sh",
	"lua=lua",
}
-- barbar
vim.g.bufferline = {
	auto_hide = true,
	icon_separator_active = "",
	icon_separator_inactive = "",
	icon_close_tab = "",
	icon_close_tab_modified = "",
}
-- vim.opt.spelloptions = "camel"
vim.g.operator_sandwich_no_default_key_mappings = 1

-- vim.g.matchup_matchparen_hi_surround_always = 1
-- vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_offscreen = { method = "status" }
-- vim.g.matchup_matchparen_offscreen = { method = "popup" }
