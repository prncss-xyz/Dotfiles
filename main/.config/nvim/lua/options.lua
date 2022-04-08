local indent = 2

local deep_merge = require('utils').deep_merge
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
    autosave = 1,
    u_lsp_lines = false,
    u_pane_width = 40,
  },
  wo = {
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
  },
  -- like set
  opt = {
    diffopt = 'internal,filler,closeoff,algorithm:patience',
    cc = '+1',
    conceallevel = 2,
    exrc = false, -- allow project local vimrc files example .nvimrc see :h exrc
    fillchars = 'eob: ', -- remove annoying tildes in gutter beneath file buffer
    foldlevel = 20,
    -- foldlevelstart=20,
    lazyredraw = true, -- when running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
    secure = true, -- disable autocmd etc for project local vimrc files
    sessionoptions = 'curdir,folds,tabpages,winsize',
    spell = true,
    spelloptions = 'camel',
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

-- neovim-qt
if not vim.fn.exists 'GuiFont' then
  vim.opt.guifont = 'Victor Mono:h8'
end

require('utils').augroup('MarkdownOptions', {
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
