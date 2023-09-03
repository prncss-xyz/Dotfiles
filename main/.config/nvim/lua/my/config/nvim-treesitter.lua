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
      'vim', -- noice.nvim needs it
    },
    highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = { 'markdown' },
    },
    indent = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocommand = false,
    },
  }

  -- installs relevant grammar on file opening
  local group = vim.api.nvim_create_augroup('MyTS', {})
  local ts_parsers = require 'nvim-treesitter.parsers'
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*' },
    group = group,
    callback = function()
      local ft = vim.bo.filetype
      local parser = ts_parsers.filetype_to_parsername[ft]
      if not parser then
        return
      end
      local is_installed = ts_parsers.has_parser(ts_parsers.ft_to_lang(ft))
      if not is_installed then
        vim.cmd { cmd = 'TSInstall', args = { parser } }
      end
    end,
  })
end

return M
