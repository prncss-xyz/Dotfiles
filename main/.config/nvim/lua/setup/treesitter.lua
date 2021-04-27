require "nvim-treesitter.configs".setup {
  rainbow = {
    enable = true
  },
  autotag = {
    enable = true
  },
  ensure_installed = "maintained",
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
      vue = {
        style_element = "// %s"
      }
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
