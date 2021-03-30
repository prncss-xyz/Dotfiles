local g = vim.g
local fn = vim.fn
local hidden_line
local old_signcolumn
local old_scrolloff
local old_left
local old_mid
local old_right

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

function _G.__goyo_enter()
  old_left = require "galaxyline".section.left
  old_right = require "galaxyline".section.right
  require "galaxyline".section.left = require "setup/galaxyline".left
  require "galaxyline".section.right = require "setup/galaxyline".right
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
  require "galaxyline".section.left = old_left
  require "galaxyline".section.right = old_right
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
