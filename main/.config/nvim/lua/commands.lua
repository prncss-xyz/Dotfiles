local Job = require("plenary/job")
local utils = require("utils")
local job_sync = utils.job_sync
local command = require("utils").command
local dotfiles = os.getenv("DOTFILES")
command("ToggleQuickFix", {}, function()
	for _, win in pairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end)
command("ExportTheme", { nargs = 1 }, function(name)
	require("theme-exporter").export_theme(name)
end)
command("AutoSearchSession", {}, function()
	local pr = job_sync(vim.fn.expand("~/.local/bin/project_root"), {})[1]
	if pr then
		vim.cmd("cd " .. pr)
	end
	if not pr then
		vim.cmd("SearchSession")
	end
end)
command("LaunchOSV", {}, function()
	local filetype = vim.bo.filetype
	if filetype == "lua" then
		require("osv").launch({ type = "server", host = "127.0.0.1", port = 30000 })
	end
end)
command("CheatDetect", {}, function()
	vim.cmd("Cheat " .. vim.bo.filetype .. " ")
end)
command("EditSnippet", {}, function()
	vim.cmd(string.format(":edit %s/main/.config/nvim/textmate/%s.json", dotfiles, vim.bo.filetype))
end)
command("NpmRun", { nargs = 1 }, function(task)
	Job
		:new({
			command = vim.env.TERMINAL,
			args = { "-e", "fish", "-C", "npm run " .. task },
		})
		:start()
end)
command("PnpmInstall", { nargs = 1 }, function(name)
	vim.cmd("!pnpm i " .. name)
end)
command("PnpmInstallDev", { nargs = 1 }, function(name)
	vim.cmd("!pnpm i -D " .. name)
end)
-- TODO select with telescope
command("PnpmRemove", { nargs = 1 }, function(name)
	vim.cmd("!pnpm rm " .. name)
end)
command( -- FIXME
	"NN",
	{ nargs = 1 },
	function(name)
		local dir = vim.fn.expand("%:p:h")
		dir = dir or ur.cwd
		local _, _, dir1, file = string.find(name, "(.+)/(.*)")
		if dir1 then
			vim.cmd("!mkdir -p " .. dir .. "/" .. dir1)
			if #file > 0 then
				vim.cmd("edit " .. dir .. "/" .. dir1 .. "/" .. file)
			end
		else
			vim.cmd("edit " .. name)
		end
	end
)
command("T", {}, function()
	Job
		:new({
			command = vim.env.TERMINAL,
			args = {},
		})
		:start()
end)
command("F", {}, function()
	Job
		:new({
			command = vim.env.TERMINAL,
			args = { "-e", "nnn" },
		})
		:start()
end)
command("Tig", {}, function()
	Job
		:new({
			command = vim.env.TERMINAL,
			args = { "-e", "tig" },
		})
		:start()
end)
command("Reload", {}, function()
	vim.cmd([[
      update
      luafile %
    ]])
end)
-- voir note ddg
command("Searchcword", {}, function()
  local word = vim.fn.expand("<cword>")
  local qs = require'utils'.encode_uri(word)
  local url = 'https://developer.mozilla.org/en-US/search?q=' .. qs
	Job
		:new({
			command = "browser",
			args = { url },
		})
		:start()
end)

require("telescope/md")
