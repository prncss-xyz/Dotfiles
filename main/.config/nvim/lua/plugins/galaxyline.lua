local M = {}

local vim = vim

-- Galaxyline seams to make Neogit flicker. We need to change to a maintained statusline, anyhow.

local short_line_list = {}
-- local short_line_list = { 'NvimTree', 'Outline', 'Trouble', 'DiffviewFiles' }
local no_num_list = {
  'NvimTree',
  'Outline',
  'Trouble',
  'DiffviewFiles',
  'Outline',
  'Trouble',
  'LuaTree',
  'dbui',
  'help',
  'dapui_scopes',
  'dapui_breakpoints',
  'dapui_stacks',
  'dapui_watches',
  'dap-repl',
  'dap-scopes',
}

-- TODO:
local function debugger()
  if not package.loaded['dap'] then
    return ''
  end
  return require('dap').status()
end

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
    if icons_enabled then
      table.insert(parts, string.format('%s%s', symbol.icon, symbol.name))
    else
      table.insert(parts, symbol.name)
    end
  end

  return table.concat(parts, separator)
end

-- The API to output the symbols structure
local function output_symbols_structure(depth, separator, icons_enabled)
  local symbols = require('aerial').get_location(true)
  local symbols_structure = format_status(
    symbols,
    depth,
    separator,
    icons_enabled
  )
  return symbols_structure
end

-- local skipLock = { 'Outline', 'Trouble', 'LuaTree', 'dbui', 'help' }
local skip_lock = {}

local user_icons = {}

local unknown_icon = ''

-- TODO: find icons for relevant buffer types
local buf_icon = {
  help = ' ',
  Trouble = ' ',
  Outline = ' ',
  DiffviewFiles = ' ',
  NvimTree = ' ',
}

local function get_file_icon()
  local icon = ''
  if vim.fn.exists '*WebDevIconsGetFileTypeSymbol' == 1 then
    icon = vim.fn.WebDevIconsGetFileTypeSymbol()
    return icon .. ' '
  end
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    print "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
    return ''
  end
  local f_name = vim.fn.expand '%:t'
  local f_extension
  vim.fn.expand '%:e'
  icon = devicons.get_icon(f_name, f_extension)
  if icon == nil then
    if user_icons[vim.bo.filetype] ~= nil then
      icon = user_icons[vim.bo.filetype][2]
    elseif user_icons[f_extension] ~= nil then
      icon = user_icons[f_extension][2]
    else
      icon = unknown_icon
    end
  end
  return icon .. ' '
end

local function get_buffer_type_icon()
  return buf_icon[vim.bo.filetype]
end

local trouble_mode = function()
  local mode = require('trouble.config').options.mode
  if mode == 'workspace_diagnostics' then
    return 'Workspace diagnostics'
  end
  if mode == 'document_diagnostics' then
    return 'Document diagnostics'
  end
  if mode == 'references' then
    return 'References'
  end
  if mode == 'definitions' then
    return 'Definitions'
  end
  if mode == 'todo' then
    return 'Todo'
  end
  return mode
end

local get_displayed_name = function()
  if vim.b.title then
    return vim.b.title
  end

  if vim.bo.filetype == 'Trouble' then
    return trouble_mode()
  end
  if vim.bo.buftype == 'nofile' then
    return vim.bo.filetype
  end
  local file = vim.fn.expand '%:p'
  local cwd = vim.fn.getcwd()
  if file:find(cwd, 1, true) then
    return file:sub(#cwd + 2)
  end
  local home = vim.fn.getenv 'HOME'
  if file:find(home, 1, true) then
    return '~/' .. file:sub(#home + 2)
  end
  return file
end

local function get_name_iconified()
  if vim.fn.expand '%' == '' then
    return
  end
  local res = '  '
  res = res .. (get_buffer_type_icon() or get_file_icon())
  res = res .. get_displayed_name()
  return res
end

local function get_diagnostic()
  local res = {}
  for _, diag in ipairs(vim.diagnostic.get(0, nil)) do
    res[diag.severity] = (res[diag.severity] or 0) + 1
  end
  return res
end

local function get_status_icons()
  -- modified
  local file = vim.fn.expand '%:t'
  local count = 0
  local icons = {}
  if vim.fn.empty(file) ~= 1 and vim.bo.modifiable and vim.bo.modified then
    table.insert(icons, '')
  end
  -- read only
  if
    vim.bo.buftype ~= 'nofile'
    -- and vim.fn.index(skipLock, vim.bo.filetype) ~= -1
    and vim.tbl_contains(skip_lock, vim.bo.filetype)
    and vim.bo.readonly == true
  then
    table.insert(icons, '')
  end

  -- diagnostics
  local diagnostic = get_diagnostic()
  if diagnostic[vim.diagnostic.severity.ERROR] then
    table.insert(icons, '')
  end
  if diagnostic[vim.diagnostic.severity.WARN] then
    table.insert(icons, '')
  end
  local icons_string = table.concat(icons, ' ')
  if count > 0 then
    icons_string = '   ' .. icons_string
  end
  if #icons > 0 then
    icons_string = '   ' .. icons_string
  end
  return icons_string
end

local function get_name_part()
  local str = get_name_iconified()
  if str then
    str = str .. get_status_icons() .. '   '
  end
  return str
end

local coordinates = function()
  if vim.tbl_contains(no_num_list, vim.bo.filetype) then
    return
  end
  if vim.fn.expand '%' == '' then
    return
  end
  local line = vim.fn.line '.'
  local column = vim.fn.col '.'
  local line_count = vim.fn.line '$'
  return string.format(' %3d:%02d %d ', line, column, line_count)
end

function M.config()
  vim.opt.laststatus = 3
  -- vim.opt.laststatus = 2

  local gl = require 'galaxyline'
  local gls = gl.section
  gl.short_line_list = short_line_list

  local diff_add = require('utils').extract_nvim_hl 'DiffAdd'
  local diff_change = require('utils').extract_nvim_hl 'DiffChange'

  local colors = {
    warn = vim.g.terminal_color_3,
    error = vim.g.terminal_color_1,
    -- background_active = vim.g.terminal_color_14, -- TODO: use gitgutters highlight groups
    -- background_inactive = vim.g.terminal_color_12,
    -- neon colorscheme
    background_active = diff_add.fg,
    background_inactive = diff_change.fg,
    text = vim.g.terminal_color_7,
  }

  local theme = require 'theme'
  if theme.galaxyline then
    require('utils.std').deep_merge(colors, theme.galaxyline)
  end

  local text = colors.text
  local background_active = colors.background_active
  local background_inactive = colors.background_inactive

  gls.left = {
    {
      FileName = {
        provider = get_name_part,
        highlight = { text, background_active },
      },
    },
    {
      Space = {
        provider = function()
          return '   '
        end,
        highlight = { text, background_inactive },
      },
    },
    {
      NvimGPS = {
        highlight = { text, background_inactive },
        provider = function()
          return output_symbols_structure(nil, ' > ', true)
        end,
      },
    },
  }

  gls.right = {
    {
      LineColumn = {
        provider = coordinates,
        highlight = { text, background_inactive },
      },
    },
  }
end

return M
