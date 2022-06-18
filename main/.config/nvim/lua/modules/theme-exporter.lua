local M = {}

local function getColors0(name)
  local r = vim.api.nvim_exec('hi ' .. name, true)
  local bg = string.match(r, 'guibg' .. '=#([%x]+)')
  if bg then
    bg = bg:lower()
  end
  local fg = string.match(r, 'guifg' .. '=#([%x]+)')
  if fg then
    fg = fg:lower()
  end
  return bg, fg
end

local function getColors()
  local res = {}
  local bg, fg
  bg, fg = getColors0 'Normal'
  res.background = bg
  res.foreground = fg
  bg, fg = getColors0 'Visual'
  res.selection_background = bg or res.foreground
  res.selection_foreground = fg or res.background
  bg, fg = getColors0 'Cursor'
  res.cursor = fg or res.foreground
  return res
end

local dir = vim.fn.expand(
  '~/Dotfiles/main/.config/theming/theme-vars',
  nil,
  nil
)

local function export_theme(name)
  dir = vim.fn.expand(dir, nil, nil)
  local colorscheme = vim.api.nvim_exec('colorscheme', true)
  local colors = getColors()
  os.execute('mkdir -p ' .. dir)
  local dest = io.open(dir .. '/' .. name .. '-generated', 'w')
  if not dest then
    return
  end
  dest:write(string.format('export name=%q\n', name))
  dest:write(string.format('export colorscheme=%q\n', colorscheme))
  dest:write(string.format('export o_background=%q\n', vim.o.background))
  for i = 0, 15 do
    local color_name = string.format('terminal_color_%d', i)
    dest:write(
      string.format('export color%d=%s\n', i, vim.g[color_name]:sub(2):lower())
    )
  end
  dest:write(string.format('export background=%s\n', colors.background))
  dest:write(string.format('export foreground=%s\n', colors.foreground))
  dest:write(
    string.format(
      'export selection_background=%s\n',
      colors.selection_background
    )
  )
  dest:write(
    string.format(
      'export selection_foreground=%s\n',
      colors.selection_foreground
    )
  )
  dest:write(string.format('export cursor=%s\n', colors.cursor))
  dest:close()
end

function M.setup()
  vim.api.nvim_create_user_command('ExportTheme', function(a)
    export_theme(a.fargs[1])
  end, { nargs = 1 })
end

return M
