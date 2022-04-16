---@diagnostic disable: undefined-global

local function clip_to_snip()
  local clip = vim.fn.getreg '+'
  local lines = {}
  for str in clip:gmatch '[^\r\n]+' do
    table.insert(lines, str)
  end
  local res = {}
  local sp = ''
  for _ = 1, vim.bo.tabstop or 1 do
    sp = sp .. ' '
  end
  for j, line in ipairs(lines) do
    local pre = ''
    line = line:gsub('^[ \t]+', function(str)
      pre = str
      pre = pre:gsub('\t', '\\t')
      pre = pre:gsub(sp, '\\t')
      return ''
    end)
    local str = string.format('%q', line)
    str = str:sub(2, #str - 1)
    table.insert(res, t '\t\t"')
    table.insert(res, t(pre))
    table.insert(res, i(j, str))
    table.insert(res, t '"')
    if j < #lines then
      table.insert(res, t ',')
    end
    table.insert(res, t { '', '' })
  end
  return sn(1, res)
end

return {
  -- this snippet generates a textmate snippet from clipboard content
  s({ trig = 'snippet' }, {
    t '"',
    i(1, 'name'),
    t { '": {', '' },
    t { '\t"prefix": "' },
    i(2, 'prefix'),
    t { '",', '' },
    -- t { '\t"description": "' },
    -- i(3, 'description'),
    -- t { '",', '' },
    t { '\t"body": [', '' },
    d(3, clip_to_snip, {}),
    t { '\t]', '},' },
  }),
}
