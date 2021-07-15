local gl = require 'galaxyline'
local Job = require 'plenary.job'
local gls = gl.section
-- gl.short_line_list = { "LuaTree", "vista", "dbui", "goyo" }
local skipLock = { 'LuaTree', 'vista', 'dbui', 'help' }

local vim, lsp, api = vim, vim.lsp, vim.api

local getDisplayname = function()
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

local function set_title()
  -- git branch --show-current
  local branch
  Job
    :new({
      command = 'git',
      args = { 'branch', '--show-current' },
      on_exit = function(j)
        branch = j:result()[1]
      end,
    })
    :sync()
  local titlestring = ''
  if branch then
    titlestring = titlestring .. ' ' .. branch .. ' — '
  else
    titlestring = titlestring .. ' '
  end
  local home = vim.loop.os_homedir()
  local dir = vim.fn.getcwd()
  if dir == home then
    dir = '~'
  else
    local _, i = dir:find(home .. '/', 1, true)
    if i then
      dir = dir:sub(i + 1)
    end
  end
  titlestring = titlestring .. dir
  vim.cmd(string.format('let &titlestring=%q', titlestring))
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
local err = text.error

local separator = ''

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

local function get_current_file_name()
  local file = vim.fn.expand '%:t'
  if vim.fn.empty(file) == 1 then
    return ' '
  end
  return file .. ' '
end

local function lift(val)
  return function()
    return val
  end
end

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand '%:t') ~= 1 then
    return true
  end
  return false
end

local function current_line_tenth()
  local current_line = vim.fn.line '.'
  local total_line = vim.fn.line '$'
  if current_line == 1 then
    return '⊤ '
  elseif current_line == vim.fn.line '$' then
    return '⊥ '
  end
  local result = math.floor((current_line / total_line) * 10)
  return result .. ' '
end

local function pwd()
  return vim.api.nvim_eval 'b:pwd' .. ' '
  --return vim.bo.pwd
end

gls.left = {
  {
    Spacer2 = {
      provider = lift ' ',
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
      provider = function()
        set_title()
        return getDisplayname() .. ' '
      end,
      separator = separator,
      separator_highlight = { background, background2 },
      highlight = { text, background2 },
    },
  },
  {
    Spacer3 = {
      provider = lift ' ',
      highlight = { text, background },
    },
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
      highlight = { err, background },
    },
  },
  {
    DiagnosticWarn = {
      provider = diagnostic_warnings,
      highlight = { warn, background },
    },
  },
}

gls.right = {
  --  {
  --    Pwd = {
  --      provider = pwd,
  --      highlight = {text, background}
  --    }
  --  },
  {
    LineColumn = {

      provider = 'LineColumn',
      separator = ' ',
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
  {
    Teenth = {
      provider = current_line_tenth,
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
}

gls.short_line_left = {
  {
    Spacer2B = {
      provider = lift ' ',
      highlight = { text, background },
    },
  },
  {
    FileIconB = {
      provider = lift '   ',
      separarator_highlight = { text, background },
      highlight = { text, background },
    },
  },
  {
    FileNameB = {
      provider = function()
        return vim.api.nvim_eval '@%' .. ' '
      end,
      separator = ' ',
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
  {
    Spacer3B = {
      provider = lift ' ',
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

gls.short_line_right = {
  {
    LineColumnB = {
      provider = 'LineColumn',
      separator = ' ',
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
  {
    TeenthB = {
      provider = current_line_tenth,
      separator_highlight = { background, background },
      highlight = { text, background },
    },
  },
}

-- local zen = {}
-- local backgroundGoyo = vim.g.terminal_color_10
-- zen.left = {
-- 	{
-- 		Spacer2C = {
-- 			provider = lift(" "),
-- 			highlight = { text, backgroundGoyo },
-- 		},
-- 	},
-- 	{
-- 		FileNameC = {
-- 			provider = function()
-- 				return vim.fn.expand("%:t") .. " "
-- 			end,
-- 			highlight = { text, backgroundGoyo },
-- 		},
-- 	},
-- 	{
-- 		DiagnosticErrorC = {
-- 			provider = diagnostic_errors,
-- 			highlight = { text, backgroundGoyo },
-- 		},
-- 	},
-- 	{
-- 		DiagnosticWarnC = {
-- 			provider = diagnostic_warnings,
-- 			highlight = { text, backgroundGoyo },
-- 		},
-- 	},
-- }
-- zen.right = {
-- 	{
-- 		LineColumnC = {
-- 			provider = "LineColumn",
-- 			separator = " ",
-- 			separator_highlight = { background, backgroundGoyo },
-- 			highlight = { text, backgroundGoyo },
-- 		},
-- 		TeenthC = {
-- 			provider = current_line_tenth,
-- 			highlight = { text, backgroundGoyo },
-- 		},
-- 	},
-- }

-- return zen
