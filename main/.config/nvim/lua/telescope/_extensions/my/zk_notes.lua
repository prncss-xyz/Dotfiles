local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local action_utils = require 'telescope.actions.utils'
local putils = require 'telescope.previewers.utils'
local entry_display = require 'telescope.pickers.entry_display'
local previewers = require 'telescope.previewers'
local state = require 'telescope.actions.state'

local displayer = entry_display.create {
  separator = ' ',
  items = {
    { width = 16 },
    { remaining = true },
  },
}

local function new_note_action(prompt_bufnr)
  actions.close(prompt_bufnr)
  local raw = state.get_current_line()
  local dir = vim.fn.fnamemodify(raw, ':h:p')
  local title = vim.fn.fnamemodify(raw, ':t')
  require('zk').new { dir = dir, title = title }
end

local function current_dir_action(prefix, _)
  local entry = action_state.get_selected_entry()
  if not entry then
    return
  end
  local raw = entry.value.path
  local dir = vim.fn.fnamemodify(raw, ':h:p')
  if dir == '.' then
    dir = ''
  end
  -- TODO: try changing prompt with feedkeys instead
  -- would avoid deeling with `prefix`
  dir = prefix .. dir .. '/'
  vim.api.nvim_buf_set_lines(0, 0, 1, true, { dir })
  vim.api.nvim_win_set_cursor(0, { 1, dir:len() })
end

local function make_display(entry)
  local value = entry.value
  local dir = vim.fn.fnamemodify(value.path, ':h:p')
  local name = value.title or value.filenameStem
  return displayer { dir, name }
end

local function create_note_entry_maker(_)
  return function(note)
    local title = note.title or note.path
    return {
      value = note,
      path = note.absPath,
      display = make_display,
      ordinal = title,
    }
  end
end

local function make_note_previewer()
  return previewers.new_buffer_previewer {
    define_preview = function(self, entry)
      local lines = vim.split(entry.value.rawContent or '', '\n')
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      putils.highlighter(self.state.bufnr, 'markdown')
    end,
  }
end

local function show_note_picker(notes, options)
  local function cb(notes_)
    if options.multi_select == false then
      notes_ = { notes_ }
    end
    for _, note in ipairs(notes_) do
      vim.cmd('e ' .. note.absPath)
    end
  end

  pickers.new(options, {
    finder = finders.new_table {
      results = notes,
      entry_maker = create_note_entry_maker(options),
    },
    sorter = conf.file_sorter(options),
    previewer = make_note_previewer(),
    display = make_display,
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<c-cr>', new_note_action)
      map('i', '<c-f>', function(prompt_bufnr_)
        current_dir_action(options.prompt_prefix, prompt_bufnr_)
      end)
      actions.select_default:replace(function()
        if options.multi_select then
          local selection = {}
          action_utils.map_selections(prompt_bufnr, function(entry, _)
            table.insert(selection, entry.value)
          end)
          if vim.tbl_isempty(selection) then
            local entry = action_state.get_selected_entry()
            if not entry then
              actions.close(prompt_bufnr)
              return false
            end
            selection = { entry.value }
          end
          actions.close(prompt_bufnr)
          cb(selection)
        else
          actions.close(prompt_bufnr)
          cb(action_state.get_selected_entry().value)
        end
      end)
      return true
    end,
  }):find()
end

return function(options)
  options = vim.tbl_extend(
    'force',
    { multi_select = true, prompt_title = 'Zk notes', prompt_prefix = '> ' },
    options or {}
  )
  local list_options = vim.tbl_extend(
    'force',
    { select = { 'title', 'absPath', 'path', 'filenameStem', 'rawContent' } },
    options or {}
  )
  require('zk.api').list(
    options.notebook_path,
    list_options,
    function(err, notes)
      assert(not err, tostring(err))
      show_note_picker(notes, options)
    end
  )
end
