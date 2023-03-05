local M = {}

-- symbols to keep consistancy between Outiliner, cmp and gps

-- derived from onsails/lspkind-nvim
M.symbols = {
  Array = '',
  Boolean = '⊨',
  Class = '𝓒',
  Color = '',
  Constant = '',
  Constructor = '',
  Enum = 'ℰ',
  EnumMember = '',
  Event = '',
  Field = 'ﰠ',
  File = '',
  Folder = '',
  Function = '',
  Interface = 'ﰮ',
  Key = '',
  Keyword = '',
  Method = '',
  Module = '',
  Namespace = '炙',
  Null = 'NULL',
  Number = '#',
  Object = '⦿',
  Operator = '+',
  Package = '',
  Property = 'ﰠ',
  Reference = '',
  Snippet = '',
  String = '𝓐',
  Struct = 'פּ',
  Text = '',
  TypeParameter = '𝙏',
  Unit = '塞',
  Value = '',
  Variable = '',
}

M.signs = {
  -- TODO:
}

-- format symbols to be used by hrsh7th/nvim-cmp
-- derived from onsails/lspkind-nvim
function M.symbolic(kind)
  local symbol = M.symbols[kind]
  symbol = symbol and (symbol .. ' ') or ''
  return string.format('%s%s', symbol, kind)
end

return M
