local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local Job = require 'plenary/job'
local conf = require('telescope.config').values
local previewers = require 'telescope.previewers'

local opts = {
  name = 'Open markdown',
}

local function entry_maker(entry)
  return {
    display = entry,
    ordinal = entry,
    id = entry,
    value = { entry },
  }
end

local function prompt(cwd)
  local function action(prompt_bufnr)
    actions.close(prompt_bufnr)
    local entry = actions.get_selected_entry()
    local res = entry.value[1]
    Job
      :new({
        command = 'opener',
        cwd = cwd,
        args = { res },
      })
      :start()
  end
  local results
  Job
    :new({
      command = 'fd',
      cwd = cwd,
      args = { '-L', '-e', 'md', '.' },
      on_exit = function(j)
        results = j:result()
      end,
    })
    :sync()
  print(#results)
  pickers.new({
    name = opts.name,
    finder = finders.new_table {
      results = results,
      entry_maker = entry_maker,
    },
    attach_mappings = function()
      actions.select_default:replace(action)
      return true
    end,
    previewer = previewers.vim_buffer_cat.new {},
    sorter = conf.generic_sorter(),
  }):find()
end

-- prompt('/home/prncss/Media/Projects/pie2/node_modules')
prompt '~/.local/share/nvim/site'
