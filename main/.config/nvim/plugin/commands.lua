local command = vim.api.nvim_create_user_command

command('Dump', function(a)
  loadstring(string.format('dump(%s)', a.args))()
end, { nargs = '*', desc = 'dump lua expr' })

command('PutText', function(a)
  loadstring(
    string.format('require"plugins.binder.actions".put_text(%s)', a.args)
  )()
end, { nargs = '*', desc = 'dump lua expr in buffer' })
