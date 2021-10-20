local telescope = require 'telescope'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local Job = require 'plenary/job'
local conf = require('telescope.config').values

local function md_help(opts)
  opts = opts or {}
  local dir
  local cwd = vim.fn.getcwd()
  if cwd == vim.fn.getenv 'DOTFILES' then
    dir = '~/.local/share/nvim/site/pack/packer'
  elseif vim.fn.isdirectory(cwd .. '/node_modules') then
    dir = cwd .. '/node_modules'
  else
    print "Don't have anywere to search"
    return
  end
  local function action(prompt_bufnr)
    actions.close(prompt_bufnr)
    local entry = actions.get_selected_entry()
    local res = entry.value
    -- TODO: catch error
    Job
      :new({
        command = 'opener',
        cwd = dir,
        args = { res .. '.md' },
      })
      :start()
  end
  pickers.new({
    prompt_title = 'markdown help',
    result_title = 'caca',
    finder = finders.new_oneshot_job(
      { 'fd', '-L', '-e', 'md', '.', '-x', 'echo', '{.}' },
      { cwd = dir }
    ),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(action)
      return true
    end,
  }):find()
end

return telescope.register_extension { exports = { md_help = md_help } }
