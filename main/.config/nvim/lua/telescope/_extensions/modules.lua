local telescope = require 'telescope'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local actions_set = require 'telescope.actions.set'
local actions_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

-- entry_maker = function(entry)
--   local name = vim.fn.fnamemodify(entry, ':t')
--   return {
--     display = make_display,
--     name = name,
--     value = entry,
--     ordinal = name .. ' ' .. entry,
--   }
-- end,

local function modules(opts)
  opts = opts or {}
  local prompt_title
  local finder
  local cwd
  local action
  local wd = vim.fn.getcwd()
  if wd == vim.fn.getenv 'DOTFILES' then
    cwd = os.getenv 'HOME' .. '/.local/share/nvim/site/pack/' -- TODO: query that dir
    prompt_title = 'installed plugins'
    finder = finders.new_oneshot_job(
      { 'fd', '--type', 'd', '--min-depth', '3', '--max-depth', '3' },
      { cwd = cwd }
    )
    action = function(dir)
      require('telescope.builtin').git_files { cwd = dir }
    end
  elseif vim.fn.isdirectory(wd .. '/node_modules') then
    cwd = wd .. '/node_modules'
    prompt_title = 'node modules'
    finder = finders.new_oneshot_job(
      { 'fd', '-L', '--type', 'd', '--min-depth', '1', '--max-depth', '2' }, -- FIXME:
      { cwd = cwd }
    )
    action = function(dir)
      require('telescope.builtin').find_files { cwd = dir }
    end
  else
    print "Don't have anywere to search"
    return
  end
  pickers.new({
    -- previewer = -- TODO: get a previewer
    prompt_title = prompt_title,
    finder = finder,
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function(_, type)
        local entry = actions_state.get_selected_entry()
        local dir = cwd .. '/' .. entry[1]
        print('!', dir)
        if type == 'default' then
          actions._close(prompt_bufnr, true)
          action(dir)
        end
      end)
      return true
    end,
  }):find()
end

return telescope.register_extension {
  exports = { modules = modules },
}
