local M = {}

local function clear_after()
  vim.defer_fn(function()
    vim.api.nvim_create_autocmd({
      'InsertLeave',
      'CursorMoved',
    }, {
      pattern = { '*' },
      once = true,
      command = 'FzClear',
    })
  end, 0)
end

function M.fz()
  vim.fn.feedkeys ':Fz '
  vim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
    pattern = { '*' },
    once = true,
    callback = clear_after,
  })
end

function M.register_nN_repeat(nN)
  -- called after a fuzzy search with a tuple of functions that are effectively `n, N`
  local next_, prev = unpack(nN)
  require('flies.operations.move_again').register(function()
    prev()
    clear_after()
  end, function()
    next_()
    clear_after()
  end)
end

return M
