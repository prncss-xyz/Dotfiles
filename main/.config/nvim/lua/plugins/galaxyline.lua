-- configuration

local short_line_list = { 'NvimTree', 'Outline', 'Trouble', 'DiffviewFiles' }

vim.opt.laststatus = 2

-- local skipLock = { 'Outline', 'Trouble', 'LuaTree', 'dbui', 'help' }
local skipLock = {}

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

local gl = require 'galaxyline'
local gls = gl.section
gl.short_line_list = short_line_list
local gps = require 'nvim-gps'
local symbols = require('symbols').symbols
gps.setup {
  enabled = true,
  icons = {
    ['class-name'] = symbols.Class .. ' ',
    ['function-name'] = symbols.Function .. ' ',
    ['method-name'] = symbols.Method .. ' ',
    ['container-name'] = symbols.Array .. ' ',
    ['tag-name'] = symbols.Property .. ' ',
  },
  separator = ' > ',
}

local vim, lsp, api = vim, vim.lsp, vim.api

local function get_file_info()
  return vim.fn.expand '%:t', vim.fn.expand '%:e'
end

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
  local f_name, f_extension = get_file_info()
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
  if mode == 'lsp_workspace_diagnostics' then
    return 'Workspace diagnostics'
  end
  if mode == 'lsp_document_diagnostics' then
    return 'Document diagnostics'
  end
  if mode == 'lsp_references' then
    return 'References'
  end
  if mode == 'lsp_definitions' then
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
  res = res .. get_displayed_name() .. ' '
  return res
end

local coordinates = function()
  if vim.fn.expand '%' == '' then
    return
  end
  local line = vim.fn.line '.'
  local column = vim.fn.col '.'
  local line_count = vim.fn.line '$'
  return string.format('%3d:%02d %d ', line, column, line_count)
end

local function get_lsp_diagnostic()
  local res = {
    Error = 0,
    Warning = 0,
  }
  if next(lsp.buf_get_clients(0)) then
    local active_clients = lsp.get_active_clients()
    if active_clients then
      for _, client in ipairs(active_clients) do
        for diag_type in pairs(res) do
          res[diag_type] = res[diag_type]
            + lsp.diagnostic.get_count(
              api.nvim_get_current_buf(),
              diag_type,
              client.id
            )
        end
      end
    end
  end
  return res
end

local function get_status_icons()
  local icons = '  '

  -- modified
  local file = vim.fn.expand '%:t'
  if vim.fn.empty(file) ~= 1 and vim.bo.modifiable and vim.bo.modified then
    icons = icons .. ' '
  end

  -- read only
  if
    vim.bo.buftype ~= 'nofile'
    and vim.fn.index(skipLock, vim.bo.filetype) ~= -1
    and vim.bo.readonly == true
  then
    icons = icons .. ' '
  end

  -- diagnostics
  local lsp_diagnostic = get_lsp_diagnostic()
  if lsp_diagnostic.Error > 0 then
    icons = icons .. ' '
  end
  if lsp_diagnostic.Warning > 0 then
    icons = icons .. ' '
  end

  return icons
end

local function constant(val)
  return function()
    return val
  end
end

local colors = {
  warn = vim.g.terminal_color_3,
  error = vim.g.terminal_color_1,
  background = vim.g.terminal_color_4,
  background2 = vim.g.terminal_color_6,
  text = vim.g.terminal_color_7,
}

local theme = require 'theme'
if theme.galaxyline then
  require('utils').deep_merge(colors, theme.galaxyline)
end

local text = colors.text
local background = colors.background
local background2 = colors.background2

gls.left = {
  {
    FileName = {
      provider = get_name_iconified,
      highlight = { text, background2 },
    },
  },
  {
    StatusIcons = {
      provider = get_status_icons,
      highlight = { text, background },
    },
  },
  {
    nvimGPS = {
      highlight = { text, background },
      provider = function()
        return gps.get_location()
      end,
      condition = function()
        return gps.is_available()
      end,
    },
  },
}

gls.right = {
  {
    LineColumn = {
      provider = coordinates,
      highlight = { text, background },
    },
  },
}

gls.short_line_left = {
  {
    FileNameB = {
      provider = get_name_iconified,
      highlight = { text, background },
    },
  },
  {
    StatusIconsB = {
      provider = get_status_icons,
      highlight = { text, background },
    },
  },
}

gls.short_line_right = {}
