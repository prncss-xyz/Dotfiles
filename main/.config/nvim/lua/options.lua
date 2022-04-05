local indent = 2

local deep_merge = require('modules.utils').deep_merge
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
    scrolloff = 5,
    smartcase = true,
    smarttab = true,
    softtabstop = 0,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    syntax = 'on',
    tabstop = indent,
    termguicolors = true,
    undofile = false,
    updatetime = 300,
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
    -- what's that ? -- FIXME:
    autosave = 1,
    ['asterisk#keeppos'] = 1,
    -- plasticboy/vim-markdown
    -- do not seem to work in setup
    -- vim_markdown_folding_disabled = 0,
    matchup_mappings_enabled = 0,
    splitjoin_join_mapping = '',
    splitjoin_split_mapping = '',
    targets_nl = 'np',
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
    u_lsp_lines = false,
  },
  wo = {
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
  },
  -- like set
  opt = {
    -- FIXME:
    --  shada = '0,f0',
    -- The '0,f0 are the important bits, it says to not save file marks as well as save 0 marks in shada
    -- @Akinsho https://www.reddit.com/r/neovim/comments/q7bgwo/marksnvim_a_plugin_for_viewing_and_interacting/
    diffopt = 'internal,filler,closeoff,algorithm:patience',
    cc = '+1',
    conceallevel = 2,
    exrc = false, -- allow project local vimrc files example .nvimrc see :h exrc
    fillchars = 'eob: ',
    foldlevel = 20,
    -- foldlevelstart=20,
    laststatus = 0,
    -- laststatus = full and 2 or 0,
    lazyredraw = true, -- when running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
    secure = true, -- disable autocmd etc for project local vimrc files
    sessionoptions = 'curdir,folds,tabpages,winsize',
    spell = true,
    spelloptions = "camel",
    -- textwidth = 80,
    undofile = true,
    virtualedit = 'block', -- allow cursor to move where there is no text in visual block mode,
  },
  -- like setglobal
  opt_global = {},
  -- like setlocal
  opt_local = {},
  env = {},
})

require('modules.utils').augroup('MarkdownOptions', {
  {
    events = { 'FileType' },
    targets = { 'markdown' },
    command = function()
      -- I write poetry
      deep_merge(vim.opt_local, {
        breakindent = true,
        breakindentopt = 'shift:2',
      })
    end,
  },
})
