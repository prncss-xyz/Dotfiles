vim.o["completeopt"] = "menuone,noselect"
-- If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
vim.g.vsnip_filetypes = {
  javascriptreact = {"javascript"},
  typescriptreact = {"typescript"}
}

require "compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    vsnip = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    tags = true,
    snippets_nvim = true,
    treesitter = true,
    tabnine = true
  }
}

function _G.completions()
    local npairs = require("nvim-autopairs")
    if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"]("<CR>")
        end
    end
    return npairs.check_break_line_char()
end

--[[

Create your own snippet

Snippet file will store to g:vsnip_snippet_dir per filetype.

Format description here:
https://github.com/Microsoft/language-server-protocol/blob/main/snippetSyntax.md

--]]
