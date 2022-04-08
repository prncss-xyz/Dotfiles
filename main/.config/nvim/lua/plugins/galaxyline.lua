local M = {}

local short_line_list = { 'NvimTree', 'Outline', 'Trouble', 'DiffviewFiles' }
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

local vim = vim

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
  res = res .. get_displayed_name() .. ' '
  return res
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
  return string.format('%3d:%02d %d ', line, column, line_count)
end

local function get_diagnostic()
  local res = {}
  for _, diag in ipairs(vim.diagnostic.get(0, nil)) do
    res[diag.severity] = (res[diag.severity] or 0) + 1
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
    -- and vim.fn.index(skipLock, vim.bo.filetype) ~= -1
    and vim.tbl_contains(skipLock, vim.bo.filetype)
    and vim.bo.readonly == true
  then
    icons = icons .. ' '
  end

  -- diagnostics
  local diagnostic = get_diagnostic()
  if diagnostic[vim.diagnostic.severity.ERROR] then
    icons = icons .. ' '
  end
  if diagnostic[vim.diagnostic.severity.WARN] then
    icons = icons .. ' '
  end

  return icons
end

function M.config()
  vim.opt.laststatus = 2

  local gl = require 'galaxyline'
  local gls = gl.section
  gl.short_line_list = short_line_list

  local colors = {
    warn = vim.g.terminal_color_3,
    error = vim.g.terminal_color_1,
    background_active = vim.g.terminal_color_14, -- TODO: use gitgutters highlight groups
    background_inactive = vim.g.terminal_color_12,
    text = vim.g.terminal_color_7,
  }

  local theme = require 'theme'
  if theme.galaxyline then
    require('utils').deep_merge(colors, theme.galaxyline)
  end

  local text = colors.text
  local background_active = colors.background_active
  local background_inactive = colors.background_inactive

  local gps = require 'nvim-gps'

  gls.left = {
    {
      FileName = {
        provider = get_name_iconified,
        highlight = { text, background_active },
      },
    },
    {
      Space = {
        provider = function()
          return ' '
        end,
        highlight = { text, background_inactive },
      },
    },
    {
      NvimGPS = {
        highlight = { text, background_inactive },
        provider = function()
          if gps.is_available() then
            return gps.get_location()
          end
        end,
      },
    },
  }

  gls.right = {
    {
      StatusIcons = {
        provider = get_status_icons,
        highlight = { text, background_inactive },
      },
    },
    {
      LineColumn = {
        provider = coordinates,
        highlight = { text, background_inactive },
      },
    },
  }

  gls.short_line_left = {
    {
      FileNameB = {
        provider = get_name_iconified,
        highlight = { text, background_inactive },
      },
    },
    {
      SpaceB = {
        provider = function()
          return ' '
        end,
        highlight = { text, background_inactive },
      },
    },
    {
      NvimGPSB = {
        highlight = { text, background_inactive },
        provider = function()
          if gps.is_available() then
            return gps.get_location()
          end
        end,
      },
    },
  }

  gls.short_line_right = {
    {
      StatusIconsB = {
        provider = get_status_icons,
        highlight = { text, background_inactive },
      },
    },
    {
      LineColumnB = {
        provider = coordinates,
        highlight = { text, background_inactive },
      },
    },
  }
end

return M
