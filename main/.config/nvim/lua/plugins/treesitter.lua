local deep_merge = require('utils').deep_merge
-- local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
-- parser_configs.markdown = {
--   install_info = {
--     url = 'https://github.com/ikatyang/tree-sitter-markdown',
--     files = { 'src/parser.c', 'src/scanner.cc' },
--   },
--   filetype = 'markdown',
-- }
--
local javascript = {
  __default = '// %s',
  jsx_element = '{/* %s */}',
  jsx_fragment = '{/* %s */}',
  jsx_attribute = '// %s',
  comment = '// %s',
}

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
      enable = true,
    },
    indent = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
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
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
      },
      swap = {
        enable = true,
      },
      move = {
        enable = true,
        set_jumps = true,
      },
    },
  })
)
