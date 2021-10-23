local m = {}

m.symbols = {
  -- LSP kind
  Array = '⛶',
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
  Namespace = '',
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

function m.symbolic(kind)
  local symbol = m.symbols[kind]
  symbol = symbol and (symbol .. ' ') or ''
  return string.format('%s%s', symbol, kind)
end

return m
