---@diagnostic disable: undefined-global

local M = {}

for _, lang in ipairs({ 'lua', 'haskell', 'go', 'bash', 'c', 'cpp' , 'javascript', 'typescript', }) do
  table.insert(
    M,
    s(
      lang,
      fmt(
        [[
        ```[]
        []
        ```
      ]],
        {
          t (lang),
          i(1, ''),
        },
        { delimiters = '[]' }
      )
    )
  )
end

--WAIT: (waiting for)
-- https://github.com/saadparwaiz1/cmp_luasnip/issues/58
-- https://github.com/saadparwaiz1/cmp_luasnip/issues/6

-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#dynamic-markdown-table
table.insert(
  M,
  s({ trig = 'tbl(%d+)x(%d+)', trigEngine = 'pattern' }, {
    d(1, function(_, snip)
      local nodes = {}
      local i_counter = 0
      local hlines = ''
      for _ = 1, snip.captures[2] do
        i_counter = i_counter + 1
        table.insert(nodes, t '| ')
        table.insert(nodes, i(i_counter, 'Column' .. i_counter))
        table.insert(nodes, t ' ')
        hlines = hlines .. '|---'
      end
      table.insert(nodes, t { '|', '' })
      hlines = hlines .. '|'
      table.insert(nodes, t { hlines, '' })
      for _ = 1, snip.captures[1] do
        for _ = 1, snip.captures[2] do
          i_counter = i_counter + 1
          table.insert(nodes, t '| ')
          table.insert(nodes, i(i_counter))
          print(i_counter)
          table.insert(nodes, t ' ')
        end
        table.insert(nodes, t { '|', '' })
      end
      return sn(nil, nodes)
    end),
  })
)

return M
