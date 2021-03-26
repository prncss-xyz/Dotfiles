require "telescope".setup {
  defaults = {
    file_ignore_patterns = {
      ".git/*",
      "node_modules/*"
    }
  },
  extensions = {
    frecency = {
      workspaces = {
        ["Dots"] = "/home/prncss/Dotfiles",
        ["notes"] = "/home/prncss/Personal/notes"
      }
    }
  }
}

require "telescope".load_extension("frecency")
require "telescope".load_extension("project")
