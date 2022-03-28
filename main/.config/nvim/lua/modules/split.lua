local M = {}

-- TODO: deal with visual lines (line-wrap)

-- hackish workaround
-- on my system, any delay >= 9 will do
-- erring on the cautious side
local delai = 9

-- https://github.com/rmagatti/goto-preview
-- https://github.com/wellle/visual-split.vim/blob/master/plugin/visual-split.vim

local global_opts = {
  height = 10,
  max_height = 10,
  direction = 'below', -- or 'above' or ''
}

local a = vim.api

local function count()
  print('..', vim.v.count, vim.v.count1)
  if vim.v.count == vim.v.count1 then
    return vim.v.count
  end
end

local function get_marks_pos(mode)
  -- Region is inclusive on both ends
  local mark1, mark2
  if mode == 'x' then
    mark1, mark2 = '<', '>'
  else
    mark1, mark2 = '[', ']'
  end
  local pos1 = vim.api.nvim_buf_get_mark(0, mark1)
  local pos2 = vim.api.nvim_buf_get_mark(0, mark2)
  return pos1, pos2
end

function M.normal(opts)
  opts = opts and vim.tbl_extend('keep', opts, global_opts) or global_opts
  local height = count() or opts.height
  local win = a.nvim_get_current_win()
  vim.cmd(opts.direction .. tostring(height) .. 'split ' .. '')
  vim.cmd 'setlocal scrolloff=0' -- also working
  a.nvim_feedkeys('zt', 'n', true)
  vim.defer_fn(function()
    a.nvim_set_current_win(win)
  end, delai)
end

-- close without f*cking the layout
function M.close(opts)
  opts = opts and vim.tbl_extend('keep', opts, global_opts) or global_opts
  -- TODO:
end

function M.visual(opts)
  opts = opts and vim.tbl_extend('keep', opts, global_opts) or global_opts
  local height = count()
  if not height then
    local pos1, pos2 = get_marks_pos 'x'
    height = math.abs(pos2[1] - pos1[1]) + 1
    if height > opts.max_height then
      height = opts.max_height
    end
  end
  local win = a.nvim_get_current_win()
  vim.cmd(opts.direction .. tostring(height) .. 'split ' .. '')
  vim.cmd 'setlocal scrolloff=0' -- also working
  a.nvim_feedkeys('zt', 'n', true)
  vim.defer_fn(function()
    a.nvim_set_current_win(win)
  end, delai)
end

function M.resize(opts)
  opts = opts and vim.tbl_extend('keep', opts, global_opts) or global_opts
  local pos1, pos2 = get_marks_pos 'x'
  local height = math.abs(pos2[1] - pos1[1]) + 1
  if height > opts.max_height then
    height = opts.max_height
  end
  vim.cmd('resize' .. tostring(height))
  vim.cmd 'setlocal scrolloff=0'
  a.nvim_feedkeys('zt', 'n', true)
end

local function handle(result, opts)
  if not result then
    return
  end
  result = result[1] or result
  Dump(result)
  -- local target = result.targetRange or result.targetSelectionRange
  -- local line = target.start.line
  -- local col = target.start.character
  -- local file = result.targetUri:sub(8)
  --
  -- -- TODO: evaluate treesitter query to deverminate definition size
  --
  -- local win = a.nvim_get_current_win()
  -- vim.cmd(opts.direction .. tostring(opts.height) .. 'split ' .. file)
  --
  -- -- vim.api.nvim_win_set_var(0, 'scrolloff', 0) -- not working
  -- -- vim.wo.scrolloff = 0 -- weirdly working
  -- vim.cmd 'setlocal scrolloff=0' -- also working
  --
  -- a.nvim_win_set_cursor(0, { line + 1, col })
  -- a.nvim_feedkeys('zt', 'n', true)
  -- vim.defer_fn(function()
  --   a.nvim_set_current_win(win)
  -- end, delai)
end

local function handler(lsp_call, opts)
  return function(_, result, _, _)
    handle(result, opts)
  end
end

--- Preview definition.
--- @param opts table: Custom config
---        • focus_on_open boolean: Focus the floating window when opening it.
---        • dismiss_on_move boolean: Dismiss the floating window when moving the cursor.
--- @see require("goto-preview").setup()
function M.lsp(opts)
  opts = opts and vim.tbl_extend('keep', opts, global_opts) or global_opts
  opts.height = opts.height or count()
  local params = vim.lsp.util.make_position_params()
  local lsp_call = 'textDocument/definition'
  local success, _ = pcall(
    vim.lsp.buf_request,
    0,
    lsp_call,
    params,
    handler(lsp_call, opts)
  )
  if not success then
    print('The current language might not be supported.', lsp_call)
  end
end

return M
