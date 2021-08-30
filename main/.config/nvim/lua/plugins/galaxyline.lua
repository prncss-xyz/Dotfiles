local gps = require("nvim-gps")
local gl = require 'galaxyline'
local Job = require 'plenary.job'
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'Outline', 'Trouble' }
local skipLock = { 'Outline', 'Trouble', 'LuaTree', 'dbui', 'help' }

local vim, lsp, api = vim, vim.lsp, vim.api

local trouble_mode = function()
  local mode = require 'trouble.config'.options.mode
  if mode == 'lsp_workspace_diagnostics' then
    return 'workspace diagnostics'
  end
  if mode == 'lsp_document_diagnostics' then
    return 'document diagnostics'
  end
  if mode == 'lsp_references' then
    return 'references'
  end
  if mode == 'lsp_definitions' then
    return 'definitions'
  end
  return mode
end

local getDisplayname = function()
  if vim.bo.filetype == 'Trouble' then
    return trouble_mode()
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

local line_column = function()
  local line = vim.fn.line '.'
  local column = vim.fn.col '.'
  return string.format('%3d:%02d ', line, column)
end

-- get current file name
local function modified()
  local file = vim.fn.expand '%:t'
  if vim.fn.empty(file) == 1 then
    return ''
  end
  if vim.bo.modifiable then
    if vim.bo.modified then
      return ' '
    end
  end
  return ''
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
local warn = colors.warn
local err = colors.error

local function get_nvim_lsp_diagnostic(diag_type)
  if next(lsp.buf_get_clients(0)) == nil then
    return false
  end
  local active_clients = lsp.get_active_clients()

  if active_clients then
    for _, client in ipairs(active_clients) do
      if
        lsp.diagnostic.get_count(
          api.nvim_get_current_buf(),
          diag_type,
          client.id
        ) > 0
      then
        return true
      end
    end
  end
  return false
end

local function diagnostic_errors()
  if get_nvim_lsp_diagnostic 'Error' then
    return ' '
  end
  return ''
end

local function diagnostic_warnings()
  if get_nvim_lsp_diagnostic 'Warning' then
    return ' '
  end
  return ''
end

local function readonly()
  if vim.fn.index(skipLock, vim.bo.filetype) ~= -1 then
    return ''
  end
  if vim.bo.readonly == true then
    return ' '
  end
  return ''
end

local function constant(val)
  return function()
    return val
  end
end

local function line_count()
  return vim.fn.line '$'
end

gls.left = {
  {
    Spacer2 = {
      provider = constant ' ',
      highlight = { text, background2 },
    },
  },
  {
    BufferIcon = {
      provider = 'BufferIcon',
      separarator_highlight = { text, background2 },
      highlight = { text, background2 },
    },
  },
  {
    FileIcon = {
      provider = 'FileIcon',
      separarator_highlight = { text, background2 },
      highlight = { text, background2 },
    },
  },
  {
    FileName = {
      provider = getDisplayname,
      -- separator = separator,
      separator_highlight = { background, background2 },
      highlight = { text, background2 },
    },
  },
  {
    Spacer3 = {
      provider = constant ' ',
      highlight = { text, background },
    }
  },
  {
    Readonly = {
      provider = readonly,
      highlight = { text, background },
    },
  },
  {
    Modified = {
      provider = modified,
      highlight = { text, background },
    },
  },
  {
    DiagnosticError = {
      provider = diagnostic_errors,
      highlight = { text, background },
    },
  },
  {
    DiagnosticWarn = {
      provider = diagnostic_warnings,
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
      provider = line_column,
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
  {
    LineCount = {
      provider = line_count,
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
  {
    Space = {
      provider = function()
        return ' '
      end,
      highlight = { text, background },
    },
  },
}

gls.short_line_left = {
  {
    Spacer2B = {
      provider = constant ' ',
      highlight = { text, background },
    },
  },
  {
    FileIconB = {
      provider = constant '   ',
      separarator_highlight = { text, background },
      highlight = { text, background },
    },
  },
  {
    FileNameB = {
      provider = getDisplayname,
      separator = ' ',
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
  {
    Spacer3B = {
      provider = constant ' ',
      highlight = { text, background },
    },
  },
  {
    ReadonlyB = {
      provider = readonly,
      highlight = { text, background },
    },
  },
  {
    ModifiedB = {
      provider = modified,
      highlight = { text, background },
    },
  },
  {
    DiagnosticErrorB = {
      provider = diagnostic_errors,
      highlight = { err, background },
    },
  },
  {
    DiagnosticWarnB = {
      provider = diagnostic_warnings,
      highlight = { warn, background },
    },
  },
}
