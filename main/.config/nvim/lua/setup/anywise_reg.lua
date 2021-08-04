require('anywise_reg').setup {
  -- FIXME: not working with cutlass
  operators = { 'y', 'd' },
  textobjects = {
    { 'i', 'a' },
    { 'w', 'W' },
  },
  paste_keys = {
    ['p'] = 'p',
  },
  register_print_cmd = true,
}
