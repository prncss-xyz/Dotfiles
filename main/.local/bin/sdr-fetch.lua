#!/usr/bin/lua5.1

local filepath = arg[1]
local parsed = dofile(filepath)
local res = {}
for k, v in pairs(parsed.highlight) do
  for _, highlight in pairs(v) do
    table.insert(res, {
      page = k,
      chapter = highlight.chapter,
      text = highlight.text,
    })
  end
end
table.sort(res, function(a, b)
  return a.page < b.page
end)
local chapter = ''
local first = true
for _, v in ipairs(res) do
  if chapter ~= v.chapter then
    chapter = v.chapter
    print('## ' .. chapter)
  elseif not first then
    print()
  end
  first = false
  print(string.format('%s (%d)', v.text, v.page))
end
