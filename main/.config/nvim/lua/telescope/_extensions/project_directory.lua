local telescope = require 'telescope'
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

local function project_directory(opts)
  opts = opts or {}
  local cwd = os.getenv 'PROJECTS'
  pickers.new({
    prompt_title = 'installed plugins',
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
        print(dir)
        if type == 'default' then
          actions._close(prompt_bufnr, true)
          project_files { cwd = dir }
        end
      end)
      return true
    end,
  }):find()
end

return telescope.register_extension {
  exports = { project_directory = project_directory },
}
