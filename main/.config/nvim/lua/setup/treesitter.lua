local M = {}
local deep_merge = require('utils').deep_merge
function M.setup()
  require('nvim-treesitter.configs').setup(
    deep_merge(require('bindings').plugins.treesitter, {
      rainbow = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      ensure_installed = {
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
          javascript = {
            __default = '// %s',
            jsx_element = '{/* %s */}',
            jsx_fragment = '{/* %s */}',
            jsx_attribute = '// %s',
            comment = '// %s',
          },
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
end

return M
