return {
  {
    'akinsho/toggleterm.nvim',
    opts = {
      direction = 'float',
      on_open = function(term)
        require('my.utils.terminal').on_open(term)
      end,
      size = function(term)
        if term.direction == 'horizontal' then
          return require('my.parameters').pane_width
        end
        return vim.o.columns * 0.4
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
