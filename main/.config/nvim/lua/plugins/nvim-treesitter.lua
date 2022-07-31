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
      'markdown',
      'markdown_inline',
      'bash',
      'c',
      'css',
      'fish',
      'go',
      'graphql',
      'html',
      'javascript',
      'json',
      'lua',
      'python',
      'query',
      'ql',
      'regex',
      'toml',
      'tsx',
      'typescript',
      'yaml',
    },
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

  -- installs relevant grammer on file opening
  local group = vim.api.nvim_create_augroup('MyTS', {})
  local ts_parsers = require 'nvim-treesitter.parsers'
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*' },
    group = group,
    callback = function()
      local ft = vim.bo.filetype
      if not ft then
        return
      end
      local parser = ts_parsers.filetype_to_parsername[ft]
      if not parser then
        return
      end
      local is_installed = ts_parsers.has_parser(ts_parsers.ft_to_lang(ft))
      if not is_installed then
        vim.cmd('TSInstall ' .. parser)
      end
    end,
  })
end

return M
