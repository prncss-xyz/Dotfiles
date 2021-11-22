local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

local full = require('pager').full

local keymaps = {}
local goto_next_start = {}
local goto_previous_end = {}
-- @scopename.inner
-- @statement.outer
-- @iswap-list
for _, name in ipairs {
  'block',
  'call',
  'class',
  'comment',
  'conditional',
  'frame',
  'function',
  'loop',
  'parameter',
  'string',
} do
  for _, scope in pairs { 'inner', 'outer' } do
    keymaps[string.format('<Plug>(%s-%s)', name, scope)] = string.format(
      '@%s.%s',
      name,
      scope
    )
    goto_next_start[string.format('<Plug>(gns-%s-%s)', name, scope)] =
      string.format(
        '@%s.%s',
        name,
        scope
      )
    goto_previous_end[string.format('<Plug>(gpe-%s-%s)', name, scope)] =
      string.format(
        '@%s.%s',
        name,
        scope
      )
  end
end
keymaps['aL'] = '@iswap-list'

local textobjects = {
  select = {
    enable = full,
    lookahead = true,
    keymaps = keymaps,
  },
  move = {
    enable = full,
    set_jumps = true,
    goto_previous_end = goto_previous_end,
    goto_next_start = goto_next_start,
  },
}

parser_configs.norg = {
  install_info = {
    url = 'https://github.com/nvim-neorg/tree-sitter-norg',
    files = { 'src/parser.c', 'src/scanner.cc' },
    branch = 'main',
  },
}

-- parser_configs.markdown = {
--   install_info = {
--     url = 'https://github.com/ikatyang/tree-sitter-markdown',
--     files = { 'src/parser.c', 'src/scanner.cc' },
--   },
--   filetype = 'markdown',
-- }

local conf = {
  rainbow = {
    enable = true,
    extended_mode = true,
  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    -- 'norg',
    -- 'markdown',
    'bash',
    'c',
    'cpp',
    'css',
    'elm',
    'fish',
    'go',
    'graphql',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'latex',
    'lua',
    'php',
    'python',
    'ql',
    'regex',
    'rust',
    'scss',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'vue',
    'yaml',
  },
  -- ensure_installed = "maintained",
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  incremental_selection = {
    enable = false,
  },
  indent = {
    enable = full,
  },
  context_commentstring = {
    enable = full,
    enable_autocommand = false,
  },
  matchup = {
    enable = true,
  },
  textobjects = textobjects,
}

-- conf = require('modules.utils').deep_merge(conf, require('modules.binder').captures.treesitter)
require('nvim-treesitter.configs').setup(conf)
