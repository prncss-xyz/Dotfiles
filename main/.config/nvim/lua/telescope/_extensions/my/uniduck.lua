local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local actions_set = require 'telescope.actions.set'
local actions_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

local uniduck_dir = vim.fn.getenv 'UNIDUCK_DIR'
local browser = vim.fn.getenv 'BROWSER'

local function browse_url(url)
  require('plenary').job
    :new({
      command = browser,
      args = { url },
    })
    :start()
end

local function on_choice(choice)
  local url = 'file://' .. uniduck_dir .. '/' .. choice
  dump(url)
  browse_url(url)
end

local function find(ft_)
  local fts
  if ft_ == 'typescriptreact' then
    fts = { 'javascriptreact', 'css', 'typescript', 'javascript' }
  elseif ft_ == 'javascriptreact' then
    fts = { 'javascriptreact', 'css', 'javascript' }
  elseif ft_ == 'typescript' then
    fts = { 'typescript', 'javascript' }
  else
    fts = { ft_ }
  end
  local items = {}
  for _, ft in ipairs(fts) do
    local filename = uniduck_dir .. '/' .. ft .. '.csv'
    local file = io.open(filename, 'r')
    if file then
      for line in file:lines() do
        table.insert(items, vim.split(line, '\t'))
      end
      file:close()
    end
  end

  return items
end

local function entry_maker(item)
  local name, path = unpack(item)
  return {
    ordinal = name,
    value = path,
    display = name,
    id = name,
  }
end

return function(opts)
  opts = opts or {}
  local ft_ = opts.filetype or vim.bo.filetype
  if ft_ == '' then
    return
  end
  local results = find(ft_)
  pickers.new({
    prompt_title = 'uniduck',
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or entry_maker,
    },
    previewer = opts.previewer,
    sorter = opts.sorter or conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function(_, type)
        local choice = actions_state.get_selected_entry()
        if type == 'default' then
          actions.close(prompt_bufnr)
          on_choice(choice.value)
        end
      end)
      return true
    end,
  }, nil):find()
end
