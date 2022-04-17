local M = {}

function M.config()
  local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
  parser_configs.norg = {
    install_info = {
      url = 'https://github.com/nvim-neorg/tree-sitter-norg',
      files = { 'src/parser.c', 'src/scanner.cc' },
      branch = 'main',
    },
  }
  require('nvim-treesitter.configs').setup {
    rainbow = {
      enable = true,
      extended_mode = true,
    },
    autotag = {
      enable = true,
    },
    endwise = {
      enable = true,
    },
    ensure_installed = {
      -- 'norg',
      'markdown',
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
      'query',
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
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocommand = false,
    },
    matchup = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
      },
      move = {
        enable = true,
        set_jumps = true,
      },
      swap = {
        enable = true,
      },
    },
  }
end

return M
