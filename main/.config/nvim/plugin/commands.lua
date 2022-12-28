local command = vim.api.nvim_create_user_command

command('PutText', function(a)
  loadstring(
    string.format('require"plugins.binder.actions".put_text(%s)', a.args)
  )()
end, { nargs = '*', desc = 'dump lua expr in buffer' })
