local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local state = require 'telescope.actions.state'
local conf = require('telescope.config').values

local function edit(path)
  vim.cmd('edit ' .. path)
end

return function (opts)
  opts = opts or {}
  local dir
  local cwd = vim.fn.getcwd()
  if cwd == vim.fn.getenv 'DOTFILES' then
    dir = vim.fn.getenv 'HOME' .. '/.local/share/nvim/site/pack/packer'
  elseif vim.fn.isdirectory(cwd .. '/node_modules') then
    dir = cwd .. '/node_modules'
  else
    print "Don't have anywere to search"
    return
  end
  pickers.new({
    prompt_title = 'markdown help',
    finder = finders.new_oneshot_job(
      { 'fd', '-L', '-e', 'md', '.', '-x', 'echo', '{.}' },
      { cwd = dir }
    ),
    -- TODO: quit when empty
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local entry = state.get_selected_entry()
        local res = entry[1]
        local path = dir .. '/' .. res .. '.md'
        -- open(path)
        edit(path)
      end)
      return true
    end,
  }):find()
end

