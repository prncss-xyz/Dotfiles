-- if `.gitignore` exists, just opens it; if not pick a gitignore files and copy it before opening
--
 -- TODO: https://github.com/github/choosealicense.com/blob/gh-pages/_licenses/gpl-3.0.txt

local telescope = require 'telescope'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local Job = require 'plenary/job'
local conf = require('telescope.config').values
local actions_set = require 'telescope.actions.set'
local actions_state = require 'telescope.actions.state'
local repo = os.getenv 'PROJECTS' .. '/gitignore'

local function create(path)
  Job
    :new({
      command = 'cp',
      args = { path, '.gitignore' },
    })
    :sync()
  vim.cmd 'e .gitignore'
end

local function gitignore(opts)
  if vim.fn.filereadable '.gitignore' == 1 then
    vim.cmd 'e .gitignore'
    return
  end
  opts = opts or {}
  pickers.new({
    prompt_title = 'gitignore templates',
    finder = finders.new_oneshot_job(
      { 'fd', '-e', 'gitignore', '.', '-x', 'echo', '{.}' },
      { cwd = repo }
    ),
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions_set.select:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local entry = actions_state.get_selected_entry()[1]
        local path = repo .. '/' .. entry .. '.gitignore'
        create(path)
      end)
      return true
    end,
  }):find()
end

return telescope.register_extension { exports = { gitignore = gitignore } }
