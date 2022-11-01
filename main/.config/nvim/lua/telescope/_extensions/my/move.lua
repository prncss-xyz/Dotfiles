local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local actions_set = require 'telescope.actions.set'
local actions_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local Job = require('plenary').job

local function move_files(target)
  local source = vim.fn.expand '%:.'
  local dest = vim.fn.expand '%:t'
  vim.cmd { cmd = 'sav', args = { target .. dest } }
  vim.fn.delete(source)
end

return function(opts)
  opts = opts or {}
  pickers
      .new(opts, {
        prompt_title = 'move to',
        finder = finders.new_oneshot_job({ 'fd', '--type', 'd' }, {}),
        -- previewer = -- TODO: get a previewer
        sorter = conf.file_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          map('i', '<c-cr>', function()
            local dir = actions_state.get_current_line() .. '/'
            actions.close(prompt_bufnr)
            Job:new({
              command = 'mkdir',
              args = { '-p', dir },
            }):sync()
            move_files(dir)
          end)
          actions_set.select:replace(function(_, type)
            local entry = actions_state.get_selected_entry()
            local dir = entry[1]
            if type == 'default' then
              actions.close(prompt_bufnr)
              move_files(dir)
            end
          end)
          return true
        end,
      }, nil)
      :find()
end
