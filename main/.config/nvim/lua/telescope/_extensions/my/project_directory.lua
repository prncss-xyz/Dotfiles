local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local actions_set = require 'telescope.actions.set'
local actions_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

local function project_files(opts)
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

return function (opts)
  opts = opts or {}
  local cwd = os.getenv 'PROJECTS'
  pickers.new(opts, {
    prompt_title = 'projects',
    finder = finders.new_oneshot_job(
      { 'fd', '--type', 'd', '--max-depth', '1' },
      { cwd = cwd }
    ),
    -- previewer = -- TODO: get a previewer
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function(_, type)
        local entry = actions_state.get_selected_entry()
        local dir = cwd .. '/' .. entry[1]
        if type == 'default' then
          actions.close(prompt_bufnr)
          project_files { cwd = dir }
        end
      end)
      return true
    end,
  }, nil):find()
end
