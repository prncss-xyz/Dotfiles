local m = {}

local entry_display = require 'telescope.pickers.entry_display'

local displayer = entry_display.create {
  separator = ' ',
  items = {
    { width = 30 },
    { remaining = true },
  },
}

local function make_display(entry)
  return displayer {
    entry.name,
    { entry.value, 'Comment' },
  }
end

function m.entry_maker(entry)
  local name = vim.fn.fnamemodify(entry, ':t')
  return {
    display = make_display,
    name = name,
    value = entry,
    ordinal = name .. ' ' .. entry,
  }
end

return m
