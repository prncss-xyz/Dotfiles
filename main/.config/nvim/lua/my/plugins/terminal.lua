return {
  {
    'akinsho/toggleterm.nvim',
    opts = {
      direction = 'float',
      on_open = function(term)
        require('my.utils.terminal').on_open(term)
      end,
    },
    cmd = {
      'ToggleTerm',
      'ToggleTermToggleAll',
      'TermExec',
      'TermSelect',
      'ToggleTermSetName',
    },
  },
}
