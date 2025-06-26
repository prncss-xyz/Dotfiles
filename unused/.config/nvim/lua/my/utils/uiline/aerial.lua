-- https://github.com/stevearc/aerial.nvim/issues/105
local function format_status(symbols, depth, separator, icons_enabled)
  local parts = {}
  depth = depth or #symbols

  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end

  for _, symbol in ipairs(symbols) do
    local name = symbol.name
    if name == '<Anonymous>' then
      name = ''
    else
      name = name .. ' '
    end
    if icons_enabled then
      table.insert(parts, string.format('%s%s', symbol.icon, name))
    else
      table.insert(parts, name)
    end
  end

  return table.concat(parts, separator)
end

-- The API to output the symbols structure
local function output_symbols_structure(depth, separator, icons_enabled)
  local symbols = require('aerial').get_location(true)
  local symbols_structure = ' '
    .. format_status(symbols, depth, separator, icons_enabled)
  return symbols_structure
end

return function()
  -- if not package.loaded['aerial'] then
  --   return ''
  -- end
  return output_symbols_structure(nil, ' ', true)
end
