-- https://github.com/f/blob/master/lua/docs-view.lua
--
local M = {}

local cfg = {
  position = 'left',
  height = 10,
  width = require('parameters').pane_width,
}

local buf, win, prev_win

local function is_open()
  return win and vim.api.nvim_win_is_valid(win)
end

local function close()
  vim.api.nvim_win_close(win, false)
  buf, win, prev_win = nil, nil, nil
end

local function open()
  local height = cfg['height']
  local width = cfg['width']

  prev_win = vim.api.nvim_get_current_win()

  if cfg.position == 'bottom' then
    vim.api.nvim_command 'bel new'
    width = vim.api.nvim_win_get_width(prev_win)
  elseif cfg.position == 'left' then
    vim.api.nvim_command 'topleft vnew'
    height = vim.api.nvim_win_get_height(prev_win)
  else
    vim.api.nvim_command 'botright vnew'
    height = vim.api.nvim_win_get_height(prev_win)
  end

  win = vim.api.nvim_get_current_win()
  buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_win_set_height(win, math.ceil(height))
  vim.api.nvim_win_set_width(win, math.ceil(width))

  vim.api.nvim_buf_set_name(buf, 'Docs View')
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'nvim-docs-view')
  vim.api.nvim_buf_set_option(buf, 'buflisted', false)

  vim.api.nvim_set_current_win(prev_win)
end

-- FEAT: 
local function definition()
  local l, c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.lsp.buf_request(0, 'textDocument/definition', {
    textDocument = { uri = 'file://' .. vim.api.nvim_buf_get_name(0) },
    position = { line = l - 1, character = c },
  }, function(err, result, ctx, config)
    if err then
      print('definition:', err)
      return
    end
    if is_open() and result then
      vim.api.nvim_buf_set_option(buf, 'modifiable', true)
      result = result[1] or result
      local target = result.targetRange
        or result.targetSelectionRange
        or result.range
      if not target then
        return
      end
      local line = target.start.line
      local col = target.start.character
      local uri = result.targetUri or result.uri
      local filename = vim.uri_to_fname(uri)
      local cursor = { line + 0, col }

      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    end
  end)
end

local function hover()
  local l, c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.lsp.buf_request(0, 'textDocument/hover', {
    textDocument = { uri = 'file://' .. vim.api.nvim_buf_get_name(0) },
    position = { line = l - 1, character = c },
  }, function(err, result, ctx, config)
    if is_open() and result and result.contents then
      local md_lines =
        vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      md_lines = vim.lsp.util.trim_empty_lines(md_lines)
      if vim.tbl_isempty(md_lines) then
        return
      end

      vim.api.nvim_buf_set_option(buf, 'modifiable', true)
      vim.lsp.util.stylize_markdown(buf, md_lines)
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    end
  end)
end

function M.close()
  if is_open() then
    close()
  end
end

function M.reveal()
  if not is_open() then
    open()
  end
  hover()
end

function M.toggle()
  if is_open() then
    close()
  else
    open()
    hover()
  end
end

return M
