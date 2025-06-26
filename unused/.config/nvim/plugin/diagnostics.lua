local group = vim.api.nvim_create_augroup('MyDiagnostic', { clear = true })
local debounce = 1500

local handle

if false then
  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    pattern = '*', -- do not match buffers with no name
    group = group,
    callback = function()
      if handle then
        vim.loop.timer_stop(handle)
      end
      --[[ vim.diagnostic.close_float() ]]
    end,
  })

  vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'CursorMoved' }, {
    pattern = '*', -- do not match buffers with no name
    group = group,
    callback = function()
      if handle then
        vim.loop.timer_stop(handle)
      end
      if vim.api.nvim_get_mode().mode == 'n' then
        handle = vim.defer_fn(function()
          vim.diagnostic.open_float()
        end, ebounce)
      end
    end,
  })
end
