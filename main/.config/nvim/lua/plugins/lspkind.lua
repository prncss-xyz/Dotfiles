-- FIXME:
print 'lspkind init'
require('lspkind').init {
  symbol_map = {
    Array = '',
    Snippet = '',
    Field = '識',
    Variable = 'x',
    Module = 'M',
    Text = 'b',
    -- Variable = '',
  },
}

local m = {}

m.symbols = {
  -- LSP kind
  -- Class = 'ﴯ',
  Color = '',
  Constant = '',
  Constructor = '',
  EnumMember = '',
  Event = '',
  Field = 'ﰠ',
  File = '',
  Folder = '',
  Function = '',
  Keyword = '',
  Method = '',
  Module = '',
  Property = 'ﰠ',
  Reference = '',
  Snippet = '',
  Struct = 'פּ',
  Text = '',
  Unit = '塞',
  Value = '',
  Variable = '',

  -- Symbols outline
  Array = '⛶',
  Boolean = '⊨',
  Class = '𝓒',
  Enum = 'ℰ',
  Interface = 'ﰮ',
  -- Key = {icon = "🔐", hl = "TSType"},
  Namespace = '',
  Null = 'NULL',
  Number = '#',
  Object = '⦿',
  Operator = '+',
  Package = '',
  String = '𝓐',
  TypeParameter = '𝙏',
}

--[[
  codicons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
--]]

function m.symbolic(kind, opts)
  local with_text = opt_with_text(opts)

  local symbol = m.symbols[kind]
  if with_text == true then
    symbol = symbol and (symbol .. ' ') or ''
    return string.format('%s%s', symbol, kind)
  else
    return symbol
  end
end

function m.cmp_format(opts)
  if opts == nil then
    opts = {}
  end

  return function(entry, vim_item)
    vim_item.kind = m.symbolic(vim_item.kind, opts)

    if opts.menu ~= nil then
      vim_item.menu = opts.menu[entry.source.name]
    end

    if opts.maxwidth ~= nil then
      vim_item.abbr = string.sub(vim_item.abbr, 1, opts.maxwidth)
    end

    return vim_item
  end
end
