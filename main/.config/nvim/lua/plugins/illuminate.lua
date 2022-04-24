local M = {}

function M.setup()
  vim.g.Illuminate_ftblacklist = { 'NeogitStatus' }
end

function M.config()
  -- diminishes flashing while typing
  vim.api.nvim_create_autocmd('InsertEnter', {
    pattern = '*',
    callback = function()
      vim.g.Illuminate_delay = 1000
    end,
  })
  vim.api.nvim_create_autocmd('InsertEnter', {
    pattern = '*',
    callback = function()
      vim.g.Illuminate_delay = 0
    end,
  })
end

return M
