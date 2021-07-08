vim.cmd("let loaded_netrwPlugin = 1") -- disable netrw
require("options")
require("plugins")

local utils = require("utils")
local job_sync = utils.job_sync
local pr = job_sync(vim.fn.expand("~/.local/bin/project_root"), {})[1]
if pr then
	vim.cmd("cd " .. pr)
end

require("theming").setup()
require("setup/telescope")
require("theme-exporter")
require("setup/lsp")
require("lightspeed").setup({})
require("specs").setup({
	show_jumps = true,
	min_jump = 30,
	popup = {
		delay_ms = 0, -- delay before popup displays
		inc_ms = 10, -- time increments used for fade/resize effects
		blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
		width = 10,
		winhl = "PMenu",
		fader = require("specs").linear_fader,
		resizer = require("specs").shrink_resizer,
	},
	ignore_filetypes = {},
	ignore_buftypes = {
		nofile = true,
	},
})

require("treesitter-context.config").setup({
	enable = true,
})
function _G.Dump(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end

-- require('hlslens').setup {}
require("trouble").setup{}
require("commands")

require("setup/dap")
require("dapui").setup{}
require("true-zen").setup{
	integration = {
		galaxyline = true,
		gitsigns = true,
		limelight = true,
	},
	ideal_writing_area_width = 100,
}
require("zen-mode").setup{
	height = 0.9,
	plugins = {
		gitsigns = { enabled = true },
	},
	on_open = function(win)
		vim.cmd("TSContextDisable")
		vim.cmd("Limelight")
		vim.cmd('echo ""')
	end,
	on_close = function()
		vim.cmd("TSContextEnable")
		vim.cmd("Limelight!")
	end,
}

if vim.fn.isdirectory(vim.o.directory) == 0 then
	vim.fn.mkdir(vim.o.directory, "p")
end

require("telescope").load_extension("heading")
require("bindings").setup()
-- require 'setup/bufferline'
require("snippets")
require("autocommands")
vim.cmd("set title")
require("auto-session").setup{
	log_level = "error",
	-- auto_session_root_dir = "~/Personal/auto-session/",
	auto_save_enabled = true,
	auto_restore_enabled = true,
	post_restore_cmds = {
		"BufferOrderByDirectory",
		"AutoSearchSession",
	},
	pre_save_cmds = {
		"TSContextDisable",
		'lua require("dapui").close()',
		"SymbolsOutlineClose",
	},
	-- post_restore_cmds = {"BufferLineSortByDirectory"},
}
require("session-lens").setup{
	shorten_path = false,
}
require("nvim-projectconfig").load_project_config{
	project_dir = "~/Media/Projects/projects-config/",
}
require("nvim-lastplace").setup{
	lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
	lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
	lastplace_open_folds = true,
}
