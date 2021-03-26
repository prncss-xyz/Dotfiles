local g = vim.g
local fn = vim.fn
local map = require "utils".map
local hidden_line
local old_signcolumn
local old_scrolloff

local colors = {
  bg = "#282c34",
  yellow = "#fabd2f",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#afd700",
  orange = "#FF8800",
  purple = "#5d4d7a",
  magenta = "#d16d9e",
  grey = "#c0c0c0",
  blue = "#0087d7",
  red = "#ec5f67"
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

function _G.__goyo_enter()
  hidden_line = require "galaxyline".section
  require "galaxyline".section = {
    left = {
      {
        FirstElement = {
          provider = function()
            return " "
          end,
          highlight = {colors.magenta, colors.darkblue}
        }
      },
      {
        FileName = {
          provider = {"FileName"},
          condition = buffer_not_empty,
          highlight = {colors.magenta, colors.darkblue}
        }
      }
    },
    right = {},
    mid = {}
  }
  old_signcolumn = vim.wo.signcolumn
  vim.wo.signcolumn = "no"
  vim.cmd "set showtabline=0"
  vim.cmd "set laststatus=0"
  vim.cmd "set noshowmode"
  vim.cmd "set noshowcmd"
  old_scrolloff = vim.wo.scrolloff
  vim.wo.scrolloff = 999
  vim.cmd "Limelight"
end

function _G.__goyo_leave()
  vim.wo.signcolumn = old_signcolumn
  vim.cmd "set showtabline=2"
  vim.cmd "set laststatus=2"
  vim.cmd "set showmode"
  vim.cmd "set showcmd"
  vim.wo.scrolloff = old_scrolloff
  vim.cmd "Limelight!"
  require "galaxyline".section = hidden_line
end

function _G.__auto_goyo()
  local fts = {"markdown", "vimwiki"}
  if fn.index(fts, vim.bo.ft) >= 0 then
    vim.cmd "Goyo 120"
  elseif fn.exists("#goyo") > 0 then
    local bufnr = fn.bufnr("%")
    vim.cmd "Goyo!"
    fn.execute("buffer " .. bufnr)
    vim.cmd "doautocmd ColorScheme,BufEnter,WinEnter"
  end
end

vim.cmd "autocmd! User GoyoLeave nested lua __goyo_leave()"
vim.cmd "autocmd! User GoyoEnter nested lua __goyo_enter()"

-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/plugins/goyo.lua
