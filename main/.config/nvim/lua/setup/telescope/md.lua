local utils = require 'utils'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local sorters = require 'telescope.sorters'
local actions = require 'telescope.actions'
local Job = require 'plenary/job'

local function prompt(cwd)
  local function action(prompt_bufnr)
    actions.close(prompt_bufnr)
    local entry = actions.get_selected_entry()
    local res = entry.value
    -- TODO: cathch error
    Job
      :new({
        command = 'opener',
        cwd = cwd,
        args = { res .. '.md' },
      })
      :start()
  end
  pickers.new({
    prompt_title = 'markdown help',
    finder = finders.new_oneshot_job(
      { 'fd', '-L', '-e', 'md', '.', '-x', 'echo', '{.}' },
      { cwd = cwd }
    ),
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = function()
      actions.select_default:replace(action)
      return true
    end,
  }):find()
end

local function main()
  local cwd = vim.fn.getcwd()
  local dir
  if cwd == vim.fn.getenv 'DOTFILES' then
    dir = '~/.local/share/nvim/site/pack/packer'
  elseif cwd == vim.fn.getenv 'DOTFILES' .. '/main/.config/nvim' then
    dir = '~/.local/share/nvim/site/pack/packer'
  elseif vim.fn.isdirectory(cwd .. '/node_modules') then
    dir = cwd .. '/node_modules'
  end
  if dir then
    prompt(dir)
  else
    print "Don't have anywere to search"
  end
end

utils.command('Mdhelp', {}, main)
