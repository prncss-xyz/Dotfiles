local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local actions_set = require 'telescope.actions.set'
local actions_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

return function(opts)
  opts = opts or {}
  local cwd = os.getenv 'HOME' .. '/.local/share/nvim/site/pack/' -- TODO: query that dir
  pickers.new({
    prompt_title = 'installed plugins',
    finder = finders.new_oneshot_job(
      { 'fd', '--type', 'd', '--min-depth', '3', '--max-depth', '3' },
      { cwd = cwd }
    ),
    -- previewer = -- TODO: get a previewer
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function(_, type)
        local entry = actions_state.get_selected_entry()
        local dir = cwd .. entry[1]
        if type == 'default' then
          actions.close(prompt_bufnr)
          vim.cmd('lcd ' .. dir) -- TODO: escape
          require('telescope.builtin').git_files {}
        end
      end)
      return true
    end,
  }, nil):find()
end
