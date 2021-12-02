local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
parser_configs.norg = {
  install_info = {
    url = 'https://github.com/nvim-neorg/tree-sitter-norg',
    files = { 'src/parser.c', 'src/scanner.cc' },
    branch = 'main',
  },
}

local full = require('pager').full
require('nvim-treesitter.configs').setup {
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
  textobjects = {
    select = {
      enable = full,
      lookahead = true,
    },
    move = {
      enable = full,
      set_jumps = true,
    },
  },
}
