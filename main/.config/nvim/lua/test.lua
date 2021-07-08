command('ToggleQuickFix', {}, function ()
  local qf = false
  for i, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd'cclose'
      qf = true
      return
    end
  end
  vim.cmd'copen'
end)
