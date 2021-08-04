local deep_merge = require('utils').deep_merge
local indent = 2
deep_merge(vim, {
  bo = {
    expandtab = true,
    shiftwidth = indent,
    softtabstop = 0,
    tabstop = indent,
  },
  o = {
    compatible = false,
    autoindent = true,
    autoread = true,
    autowriteall = true,
    backup = false,
    clipboard = 'unnamedplus',
    cmdheight = 1,
    completeopt = 'menuone,noselect',
    cursorline = true,
    expandtab = true,
    foldexpr = '[[<cmd>lua require("nvim_treesitter").foldexpr()<cr>]]',
    foldmethod = 'expr',
    -- guifont = 'Fira Code NerdFont',
    hidden = true,
    ignorecase = true,
    incsearch = true,
    lazyredraw = true,
    linebreak = true,
    mouse = 'a',
    scrolloff = 10,
    shiftwidth = indent,
    shortmess = vim.o.shortmess .. 'c',
    showmode = false,
    sidescrolloff = 5,
    smartcase = true,
    smarttab = true,
    softtabstop = 0,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    syntax = 'on',
    tabstop = indent,
    termguicolors = true,
    undofile = true,
    updatetime = 500,
    -- timeoutlen = 300,
    wildignorecase = true,
    wildoptions = 'pum',
    pumblend = 20,
    wrap = true,
    grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]],
    -- bufhidden = "wipe",
  },
  g = {
    autosave = 1,
    indentLine_char = '│',
    rg_command = 'rg --vimgrep -S',
    -- see https://languagetool.org/http-api/swagger-ui/#!/default/post_check
    languagetool_server_command = 'echo "Server Started"',
    languagetool = {
      ['.'] = { language = 'auto' },
    },
    camelcasemotion_key = ',',
    ['asterisk#keeppos'] = 1,
    vista_icon_indent = { '╰─▸ ', '├─▸ ' },
    ['vista#renderer#enable_icon'] = 1,
    ['vista#renderer#icons'] = {
      ['function'] = '',
      ['variable'] = '',
    },
    -- indent_blankline_char_highlight_list = {"SpecialKey", "DevIconIni"},
    indent_blankline_show_current_context = true,
    indent_blankline_buftype_exclude = { 'terminal', 'help' },
    vim_markdown_folding_disabled = 1,
    vim_markdown_conceal_code_blocks = 0,
    vim_markodwn_frontmatter = 1,
    vim_markdown_toc_autofit = 1,
    vim_markdown_emphasis_multiline = 0,
    vim_markdown_frontmatter = 1,
    vim_markdown_new_list_item_indent = indent,
    markdown_fenced_languages = {
      'js=javascript',
      'jsx=javascriptreact',
      'ts=typescript',
      'tsx=typescriptreact',
      'bash=sh',
    },
    -- barbar
    bufferline = {
      auto_hide = true,
      icon_separator_active = '',
      icon_separator_inactive = '',
      icon_close_tab = '',
      icon_close_tab_modified = '',
    },
    operator_sandwich_no_default_key_mappings = 1,
    -- matchup_matchparen_hi_surround_always = 1,
    -- matchup_matchparen_deferred = 1,
    matchup_matchparen_offscreen = { method = 'status' },
    -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
    -- dap_virtual_text = true,
    dap_virtual_text = 'all frames', -- experimental
  },
  wo = {
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
  },
  opt_local = { conceallevel = 2 },
  -- vim.opt.{option}: behaves like :set
  -- vim.opt_global.{option}: behaves like :setglobal
  -- vim.opt_local.{option}: behaves like :setlocal
  opt = {
    secure = true, -- disable autocmd etc for project local vimrc files
    exrc = false, -- allow project local vimrc files example .nvimrc see :h exrc
    virtualedit = 'block', -- allow cursor to move where there is no text in visual block mode,
    lazyredraw = true, -- when running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
    -- spelloptions = "camel",
  },
  env = {
    GIT_EDITOR = 'nvr',
    EDITOR = 'nvr',
  },
})
deep_merge(vim, require('bindings').plugins.vim)
