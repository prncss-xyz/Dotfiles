require "nvim-treesitter.configs".setup {
  rainbow = {
    enable = true
  },
  autotag = {
    enable = true
  },
  ensure_installed = {"bash", "c", "cpp", "css", "elm", "fish", "go", "graphql", "html", "javascript", "jsdoc", "json", "latex", "lua", "php", "python", "ql", "regex", "rust", "scss", "svelte", "toml", "tsx", "typescript", "vue", "yaml"},
  -- ensure_installed = "maintained",
  highlight = {
    enable = true,
    use_languagetree = true
  },
  incremental_selection = {
    enable = true,
    keymaps = require "bindings".treesitter
  },
  indent = {
    enable = true
  },
  context_commentstring = {
    enable = true,
    config = {
      javascript = {
        __default = '// %s',
        jsx_element = '{/* %s */}',
        jsx_fragment = '{/* %s */}',
        jsx_attribute = '// %s',
        comment = '// %s'
      },
    }
  },
  matchup = {
    enable = true,
  },
  textsubjects = {
        enable = true,
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-big',
        }
    },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ia"] = "@parameter.inner",
        ["a,"] = {
          javascript = "(pair) @object" -- not working
        }
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner"
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner"
      }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [",f"] = "@function.outer"
      },
      goto_previous_end = {
        [",F"] = "@function.outer"
      }
    }
  }
 }
