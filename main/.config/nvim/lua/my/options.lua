local indent = 2

local deep_merge = require('my.utils.std').deep_merge
deep_merge(vim, {
  bo = {
    expandtab = false,
    shiftwidth = indent,
    softtabstop = 0,
    tabstop = indent,
  },
  o = {
    background = 'dark',
    compatible = false,
    autoindent = true,
    autoread = true,
    autowriteall = true,
    backup = false,
    -- clipboard = 'unnamedplus',
    completeopt = 'menuone,noselect',
    cursorline = true,
    expandtab = true,
    hidden = true,
    ignorecase = true,
    incsearch = true,
    linebreak = true,
    mouse = 'a',
    shiftwidth = indent,
    -- shortmess = vim.o.shortmess .. 'c',
    shortmess = 'IFc',
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
    updatetime = 300,
    undofile = true,
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
    ['conjure#extract#tree_sitter#enabled'] = true,
    gruvbox_material_background = 'soft', -- for ligth
    -- gruvbox_material_background = 'hard', -- for dark
    gruvbox_better_performance = 1,
    solarized_italics = 1,
    -- material_style = 'darker',
    -- material_style = 'lighter',
    material_style = 'oceanic',
    -- material_style = 'palenight',
    -- material_style = 'deep ocean',
    -- autosave = 1,
    Illuminate_ftblacklist = { 'NeogitStatus' },
  },
  wo = {
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
    foldlevel = 99,
    foldenable = true,
    -- foldexpr = 'My_foldexpr()',
  },
  opt = {
    diffopt = 'internal,filler,closeoff,algorithm:patience',
    cc = '+1',
    conceallevel = 2,
    exrc = false, -- allow project local vimrc files example .nvimrc see :h exrc
    fillchars = 'eob: ', -- remove annoying tildes in gutter beneath file buffer
    foldlevel = 20,
    -- foldlevelstart=20,
    paste = false,
    secure = true, -- disable autocmd etc for project local vimrc files
    sessionoptions = 'curdir,folds,tabpages,winsize',
    spell = false,
    spelloptions = 'camel',
    -- textwidth = 100,
    titlestring = '%{v:lua.my_title()}', -- defined in `globals.lua`
    undofile = true, -- FIXME: not working
    virtualedit = 'block', -- allow cursor to move where there is no text in visual block mode,
  },
  env = {},
})

vim.diagnostic.config {
  virtual_text = false,
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    -- I write poetry
    deep_merge(vim.opt_local, {
      breakindent = true,
      breakindentopt = 'shift:2',
    })
  end,
})

vim.diagnostic.config { virtual_text = false, update_in_insert = true }
