local dial = require 'dial'
dial.augends['custom#boolean'] = dial.common.enum_cyclic {
  name = 'boolean',
  strlist = { 'true', 'false' },
}

local function add(cursor, text, added)
  if text:sub(4, 4) == ' ' then
    text = '- [x]'
  else
    text = '- [ ]'
  end
  return cursor, text
end

dial.augends['custom#todo'] = {
  desc = 'toggle markdown todo',
  find = dial.common.find_pattern '- %[.%]',
  add = add,
}
dial.config.searchlist.normal = {
  'number#decimal',
  'number#hex',
  'number#binary',
  'date#[%Y-%m-%d]',
  'markup#markdown#header',
  'custom#todo',
  'custom#boolean',
}
