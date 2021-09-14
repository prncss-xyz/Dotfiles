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
    shiftwidth = indent,
    shortmess = vim.o.shortmess .. 'c',
    showmode = false,
    sidescrolloff = 5,
    scrolloff = 30,
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
    updatetime = 1000,
    -- timeoutlen = 300,
    wildignorecase = true,
    wildoptions = 'pum',
    pumblend = 20,
    wrap = true,
    grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]],
    -- bufhidden = "wipe", -- this option seams to crash auto_session
    title = true,
  },
  g = {
    autosave = 1,
    -- plasticboy/vim-markdown
    -- vim_markdown_folding_disabled = 0,
    vim_markdown_folding_level = 6,
    vim_markdown_no_default_key_mappings = 1,
    vim_markdown_conceal_code_blocks = 0,
    vim_markodwn_frontmatter = 1,
    vim_markdown_toc_autofit = 1,
    vim_markdown_emphasis_multiline = 0,
    vim_markdown_frontmatter = 1,
    vim_markdown_new_list_item_indent = vim.o.tabstop,
    markdown_fenced_languages = {
      'js=javascript',
      'jsx=javascriptreact',
      'ts=typescript',
      'tsx=typescriptreact',
      'bash=sh',
    },
    -- vim_markdown_conceal_code_blocks = 0,
    -- vim-case-chage
    casechange_nomap = 1,
  },
  wo = {
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
  },
  -- like set
  opt = {
    conceallevel = 2,
    secure = true, -- disable autocmd etc for project local vimrc files
    exrc = false, -- allow project local vimrc files example .nvimrc see :h exrc
    virtualedit = 'block', -- allow cursor to move where there is no text in visual block mode,
    lazyredraw = true, -- when running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
    -- spelloptions = "camel",
    fillchars = 'eob: ',
    sessionoptions = 'curdir,folds,tabpages,winsize',
    foldlevel = 20,
    -- foldlevelstart=20,
  },
  -- like setglobal
  opt_global = {},
  -- like setlocal
  opt_local = {},
  env = {
    GIT_EDITOR = 'nvr',
    EDITOR = 'nvr',
  },
})

deep_merge(vim, require('bindings').plugins.vim)
