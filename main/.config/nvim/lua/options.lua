local indent = 2

-- FIXME: not working

function _G.foldexpr(lnum)
  for l = lnum, 1, -1 do
    local line = vim.fn.getline(lnum)
    local _, n = line:find '^#+ '
    if n then
      return tostring(n)
    end
  end
  return '0'
end

vim.cmd [[
function! My_foldexpr() abort
  return luaeval(printf('foldexpr(%d)', v:lnum))
  endfunction
]]

local deep_merge = require('utils.std').deep_merge
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
    -- clipboard = 'unnamedplus',
    cmdheight = 1,
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
    undofile = false,
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
    -- autosave = 1,
    do_filetype_lua = 1,
    did_load_filetypes = 0,
    -- FIXME: not respected by new treesitter grammar
    markdown_fenced_languages = {
      'js=javascript',
      'ts=typescript',
      'shell=sh',
      'bash=sh',
      'console=sh',
    },
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
    lazyredraw = true, -- when running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
    paste = false,
    secure = true, -- disable autocmd etc for project local vimrc files
    sessionoptions = 'curdir,folds,tabpages,winsize',
    spell = false,
    spelloptions = 'camel',
    -- textwidth = 80,
    titlestring = '%{v:lua.my_title()}', -- defined in `globals.lua`
    undofile = true, -- FIXME: not working
    virtualedit = 'block', -- allow cursor to move where there is no text in visual block mode,
  },
  env = {},
})

vim.diagnostic.config {
  virtual_text = false,
}

-- neovim-qt
if not vim.fn.exists 'GuiFont' then
  vim.opt.guifont = 'Victor Mono:h8'
end

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
