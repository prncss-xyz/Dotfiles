local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local state = require 'telescope.actions.state'
local conf = require('telescope.config').values

local function get_dir()
  local cwd = vim.fn.getcwd()
  if cwd == require 'my.parameters'.dotfiles then
    return vim.fn.getenv 'HOME' .. '/.local/share/nvim/site/pack/packer'
  end
  if vim.fn.isdirectory(cwd .. '/node_modules') then
    return cwd .. '/node_modules'
  end
end

return function(opts)
  opts = opts or {}
  local dir = get_dir()
  if not dir then
    print "Don't have anywere to search"
    return
  end
  pickers.new(opts, {
    prompt_title = 'markdown help',
    finder = finders.new_oneshot_job(
      { 'fd', '-L', '-e', 'md', '.', '-x', 'echo', '{.}' },
      { cwd = dir }
    ),
    previewer = opts.previewer or conf.file_previewer(opts),
    sorter = opts.previewer or conf.file_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local entry = state.get_selected_entry()
        local res = entry[1]
        local path = dir .. '/' .. res .. '.md'
        vim.cmd('edit ' .. path) -- TODO: escape
      end)
      return true
    end,
  }):find()
end
