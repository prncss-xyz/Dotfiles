local M = {}

local function format_item(choice)
  return choice.name
end

local function on_choice(choice)
  if not choice then
    return
  end
  vim.cmd('edit ' .. choice.path)
end

function M.edit_snippets()
  if false then
    require('luasnip.loaders.from_lua').edit_snippet_files()
    return
  end
  local vim_dir = vim.g.vim_dir
  local snip_dir = vim_dir .. '/snippets'
  local languages = {}
  local ft = vim.bo.filetype
  if ft ~= '' then
    table.insert(languages, ft)
  end
  if ft == 'javascriptreact' then
    table.insert(languages, 'javascript')
  elseif ft == 'typescript' then
    table.insert(languages, 'javascript')
  elseif ft == 'typescriptreact' then
    table.insert(languages, 'javascriptreact')
    table.insert(languages, 'typescript')
    table.insert(languages, 'javascript')
  end
  table.insert(languages, 'all')
  local items = {}
  for _, language in ipairs(languages) do
    local item_ls = {}
    item_ls.name = language .. ' -- LuaSnip'
    item_ls.path = string.format('%s%s/%s.lua', snip_dir, '/luasnip', language)
    table.insert(items, item_ls)
    local item_tm = {}
    item_tm.name = language .. '-- TextMate'
    item_tm.path = string.format(
      '%s%s/%s.json',
      snip_dir,
      '/textmate',
      language
    )
    table.insert(items, item_tm)
  end
  table.insert(
    items,
    { name = 'bindings -- Conf', path = vim_dir .. '/lua/bindings/init.lua' }
  )
  table.insert(items, {
    name = 'textobjects -- Conf',
    path = vim_dir .. '/lua/bindings/textobjects.lua',
  })
  table.insert(
    items,
    { name = 'plugins -- Conf', path = vim_dir .. '/lua/plugins/init.lua' }
  )
  vim.ui.select(items, { format_item = format_item }, on_choice)
end

return M
