local M = {}

local function getColors(name)
	r = vim.api.nvim_exec("hi " .. name, true)
	local bg = string.match(r, "guibg" .. "=#([%x]+)")
	if bg then
		bg = bg:lower()
	end
	local fg = string.match(r, "guifg" .. "=#([%x]+)")
	if fg then
		fg = fg:lower()
	end
	return bg, fg
end

local dir = vim.fn.expand("~/.config/theming/theme")

function M.export_theme(name)
	dir = vim.fn.expand(dir)
	os.execute("mkdir -p " .. dir)
	local dest = io.open(dir .. "/" .. name, "w")
	dest:write(string.format("export name=%q\n", name))
	for i = 0, 15 do
		local color_name = string.format("terminal_color_%d", i)
		dest:write(string.format("export color%d=%s\n", i, vim.g[color_name]:sub(2):lower()))
	end
	local bg, fg
	bg, fg = getColors("Normal")
	dest:write(string.format("export background=%s\n", bg))
	dest:write(string.format("export foreground=%s\n", fg))
	local bg0, fg0 = bg, fg
	bg, fg = getColors("Visual")
	dest:write(string.format("export selection_background=%s\n", bg or fg0))
	dest:write(string.format("export selection_foreground=%s\n", fg or bg0))
	bg, fg = getColors("Cursor")
	dest:write(string.format("export cursor=%s\n", fg or fg0))
	dest:close()
end

-- https://github.com/neovim/neovim/issues/2897#issuecomment-115464516
-- local function export_theme()
-- 	local name = vim.api.nvim_exec("colorscheme", true)
-- 	local home = vim.api.nvim_eval("$HOME") .. "/"
-- 	local templateDir = home .. "Dotfiles/main/theme-templates/"
-- 	local themeDir = home .. "Dotfiles/_theme-" .. name .. "/"
-- 	local function getColor(r, id)
-- 		local no
-- 		no = string.match(r, "gui" .. id .. "=(#[%x]+)")
-- 		if no then
-- 			return no
-- 		end

-- 		no = string.match(r, "cterm" .. id .. "=(%d+)")
-- 		if no then
-- 			return vim.g["terminal_color_" .. no]
-- 		end
-- 	end

-- 	local palette = {}
-- 	local r
-- 	r = vim.api.nvim_exec("hi Normal", true)
-- 	palette.background = getColor(r, "bg")
-- 	palette.foreground = getColor(r, "fg")
-- 	r = vim.api.nvim_exec("hi Visual", true)
-- 	palette.selection_background = getColor(r, "bg") or palette.foreground
-- 	palette.selection_foreground = getColor(r, "fg") or palette.background
-- 	r = vim.api.nvim_exec("hi Cursor", true)
-- 	palette.cursor = getColor(r, "bg") or palette.foreground
-- 	for i = 0, 15 do
-- 		palette["color" .. i] = vim.g["terminal_color_" .. i]
-- 	end

-- 	local function mkTheme(fileDir, fileName)
-- 		local source = io.open(templateDir .. fileDir .. fileName, "r")
-- 		local contents = source:read("*all")
-- 		contents = contents:gsub("$([%w_]+)", function(key)
-- 			return palette[key] or ("$" .. key)
-- 		end)
-- 		source:close()
-- 		os.execute("mkdir -p " .. themeDir .. fileDir)
-- 		local dest = io.open(themeDir .. fileDir .. fileName, "w")
-- 		dest:write(contents)
-- 		dest:close()
-- 	end

-- 	mkTheme(".config/kitty/", "theme.conf")
-- 	mkTheme(".config/sway/config.d/", "theme.conf")
-- 	mkTheme(".config/waybar/", "style.css")
-- 	mkTheme("", "sampler.html")

-- 	local fileDir = ".config/nvim/lua/"
-- 	local fileName = "theme.lua"
-- 	os.execute("mkdir -p " .. themeDir .. fileDir)
-- 	local dest = io.open(themeDir .. fileDir .. fileName, "w")
-- 	dest:write(string.format("return %q", name))
-- 	dest:close()
-- 	print("done")
-- end

return M
