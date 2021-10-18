local deep_merge = require('utils').deep_merge
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

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

local javascript = {
  __default = '// %s',
  jsx_element = '{/* %s */}',
  jsx_fragment = '{/* %s */}',
  jsx_attribute = '// %s',
  comment = '// %s',
}

local full = require('pager').full

require('nvim-treesitter.configs').setup(
  deep_merge(require('bindings').plugins.treesitter, {
    rainbow = {
      enable = true,
      extended_mode = true,
    },
    autotag = {
      enable = true,
    },
    ensure_installed = {
      'norg',
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
      enable = full,
    },
    indent = {
      enable = full,
    },
    context_commentstring = {
      enable = full,
      config = {
        --        javascript = javascript,
        --      javascriptreact = javascript,
        --    typescript = javascript,
        --  typescriptreact = javascript,
      },
    },
    matchup = {
      enable = true,
    },
    textsubjects = {
      enable = full,
    },
    textobjects = {
      select = {
        enable = full,
      },
      swap = {
        enable = full,
      },
      move = {
        enable = full,
        set_jumps = full,
      },
    },
  })
)
