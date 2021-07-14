local utils = require'utils'
local pickers = require"telescope.pickers"
local finders = require"telescope.finders"
local actions = require"telescope.actions"
local Job = require"plenary/job"

local function prompt(cwd)
	local function action(prompt_bufnr)
		actions.close(prompt_bufnr)
		local entry = actions.get_selected_entry()
		local res = entry.value
		Job
			:new({
				command = "opener",
				cwd = cwd,
				args = { res },
			})
			:start()
	end
  pickers.new({
    prompt_title = 'markdown help',
    finder = finders.new_oneshot_job(
      {"fd",  "-L", "-e", "md", "." },
      {cwd = cwd}
    ),
		attach_mappings = function()
			actions.select_default:replace(action)
			return true
		end,
  }):find()
end

local function main()
  local cwd = vim.fn.getcwd()
  local dir
  if cwd == vim.fn.getenv'DOTFILES' then
    dir = "~/.local/share/nvim/site"
  else
    dir = cwd .. "/node_modules"
  end
  prompt(dir)
end

utils.command("Mdhelp", {}, main)
