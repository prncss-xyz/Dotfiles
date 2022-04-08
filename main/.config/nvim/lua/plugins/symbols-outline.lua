local M = {}

M.setup = function()
  local symbols = require('symbols').symbols
  vim.g.symbols_outline = {
    width = vim.g.u_pane_width,
    show_guides = false,
    auto_preview = false,
    position = 'left',
    symbols = {
      Array = { icon = symbols.Array, hl = 'TSConstant' },
      Boolean = { icon = symbols.Boolean, hl = 'TSBoolean' },
      Class = { icon = symbols.Class, hl = 'TSType' },
      Constant = { icon = symbols.Constant, hl = 'TSConstant' },
      Constructor = { icon = symbols.Constructor, hl = 'TSConstructor' },
      Enum = { icon = symbols.Enum, hl = 'TSType' },
      EnumMember = { icon = symbols.EnumMember, hl = 'TSField' },
      Event = { icon = symbols.Event, hl = 'TSType' },
      Field = { icon = symbols.Field, hl = 'TSField' },
      File = { icon = symbols.File, hl = 'TSURI' },
      Function = { icon = symbols.Function, hl = 'TSFunction' },
      Interface = { icon = symbols.Interface, hl = 'TSType' },
      Key = { icon = symbols.Keyword, hl = 'TSType' },
      Method = { icon = symbols.Method, hl = 'TSMethod' },
      Module = { icon = symbols.Module, hl = 'TSNamespace' },
      Namespace = { icon = symbols.Namespace, hl = 'TSNamespace' },
      Null = { icon = symbols.Null, hl = 'TSType' },
      Number = { icon = symbols.Number, hl = 'TSNumber' },
      Object = { icon = symbols.Object, hl = 'TSType' },
      Operator = { icon = symbols.Operator, hl = 'TSOperator' },
      Package = { icon = symbols.Package, hl = 'TSNamespace' },
      Property = { icon = symbols.Property, hl = 'TSMethod' },
      String = { icon = symbols.String, hl = 'TSString' },
      Struct = { icon = symbols.Struct, hl = 'TSType' },
      Variable = { icon = symbols.Variable, hl = 'TSConstant' },
    },
    show_symbol_details = false,
    symbol_blacklist = {},
    lsp_blacklist = {
      'null-ls',
    },
  }
  require('utils').augroup('Outline', {
    {
      events = { 'FileType' },
      targets = { 'Outline' },
      -- command = function()
      --   vim.opt_local.scl = 'no'
      -- end,
      command = 'setlocal scl=no',
    },
  })
end

return M
