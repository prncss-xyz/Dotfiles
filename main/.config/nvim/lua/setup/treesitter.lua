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
  }
}
