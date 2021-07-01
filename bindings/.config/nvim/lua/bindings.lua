local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

local ls = require'luasnip'

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif ls.jumpable(1) == true then
    return t "<cmd>lua require'luasnip'.expand_or_jump(1)<Cr>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif ls.jumpable() == true then
    return t "<cmd>lua require'luasnip'.expand_or_jump(-1)<Cr>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

local function setup()
  vim.g.mapleader = " "
  vim.g.user_emmet_leader_key = "<C-y>"

  -- canceling lightspeed until it works better
  map("", "f", "f")
  map("", "F", "F")
  map("", "t", "t")
  map("", "T", "T")

  map("", "<C-z>", "u")
  map("i", "<C-z>", "<esc>ui")
  map("", "<C-S-z>", "<C-R>")
  map("i", "<C-S-z>", "<C-R>")
  map("v", "<C-c>", '"+y')
  map("v", "<C-x>", '"+d')
  map("", "<M-v>", "<C-v>")
  map("", "<C-v>", '"+p')
  map("i", "<C-v>", '<Esc>"+pa')
  -- map("", "<C-l>", "<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-l>") -- Clear highlights
  map("", "<C-l>", ":noh<cr>")
  map("i", "<C-l>", ":noh<cr>")
  map("", "<C-s>", "<Esc>:w<CR>")
  map("i", "<C-s>", "<Esc>:w<CR>")
  map("t", "<C-w>", "<C-\\><C-n>")
  map("", "<C-w>L", "<cmd>vsplit<CR>")
  map("", "<C-w>J", "<cmd>split<CR>")
  map("c", "<C-n>", "<down>")
  map("c", "<C-p>", "<up>")
  map("", "gx", '<Cmd>call jobstart(["opener", expand("<cfile>")], {"detach": v:true})<CR>')
  -- from https://github.com/mhinz/vim-galore
  -- The mapping takes a register (or * by default) and opens it in the cmdline-window. Hit <cr> when you're done editing for setting the register.
  -- Use it like this <leader>m or "q<leader>m.
  -- Notice the use of <c-r><c-r> to make sure that the <c-r> is inserted literally. See :h c_^R^R.

  map("", "<C-h>", "<cmd>HopChar2<cr>")

  map("n", "<leader>m", ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>")

  map("", "<c-n>", ":edit %:h/")
  map("i", "<c-n>", "<esc>:edit %:h/")

  map("", "<C-w>x", "<cmd>Bdelete<CR>")
  map("", "<C-w><C-x>", "<cmd>bdelete!<CR>")
  map("", "<C-w><S-x>", "<cmd>BufferLineCloseRight<CR><cmd>BufferLineCloseLeft<CR>")

  -- bufferline
  map("", "<S-j>", "<cmd>BufferLineCycleNext<CR>")
  map("", "<S-k>", "<cmd>BufferLineCyclePrev<CR>")
  map("", "<A-S-j>", "<cmd>BufferLineMoveNext<CR>")
  map("", "<A-S-k>", "<cmd>BufferLineMovePrev<CR>")
  map("", "<leader>be", "<cmd>BufferLineSortByExtension<CR>")
  map("", "<leader>bd", "<cmd>BufferLineSortByDirectory<CR>")
  map("", "<A-s>", "<cmd>BufferLinePick<CR>")
  map("", "<A-1>", "<cmd>lua require'bufferline'.go_to_buffer(1)<cr>")
  map("", "<A-2>", "<cmd>lua require'bufferline'.go_to_buffer(2)<cr>")
  map("", "<A-3>", "<cmd>lua require'bufferline'.go_to_buffer(3)<cr>")
  map("", "<A-4>", "<cmd>lua require'bufferline'.go_to_buffer(4)<cr>")
  map("", "<A-5>", "<cmd>lua require'bufferline'.go_to_buffer(5)<cr>")
  map("", "<A-6>", "<cmd>lua require'bufferline'.go_to_buffer(6)<cr>")
  map("", "<A-7>", "<cmd>lua require'bufferline'.go_to_buffer(7)<cr>")
  map("", "<A-8>", "<cmd>lua require'bufferline'.go_to_buffer(8)<cr>")
  map("", "<A-9>", "<cmd>lua require'bufferline'.go_to_buffer(9)<cr>")
  map("t", "<A-1>", "<cmd>lua require'bufferline'.go_to_buffer(1)<cr>")
  map("t", "<A-2>", "<cmd>lua require'bufferline'.go_to_buffer(2)<cr>")
  map("t", "<A-3>", "<cmd>lua require'bufferline'.go_to_buffer(3)<cr>")
  map("t", "<A-4>", "<cmd>lua require'bufferline'.go_to_buffer(4)<cr>")
  map("t", "<A-5>", "<cmd>lua require'bufferline'.go_to_buffer(5)<cr>")
  map("t", "<A-6>", "<cmd>lua require'bufferline'.go_to_buffer(6)<cr>")
  map("t", "<A-7>", "<cmd>lua require'bufferline'.go_to_buffer(7)<cr>")
  map("t", "<A-8>", "<cmd>lua require'bufferline'.go_to_buffer(8)<cr>")
  map("t", "<A-9>", "<cmd>lua require'bufferline'.go_to_buffer(9)<cr>")

  -- barbar
  -- map("", "<S-j>", "<cmd>BufferNext<CR>")
  -- map("", "<S-k>", "<cmd>BufferPrevious<CR>")
  -- map("", "<A-S-j>", "<cmd>BufferMoveNext<CR>")
  -- map("", "<A-S-k>", "<cmd>BufferMovePrevious<CR>")
  -- map("", "<C-w>x", "<cmd>BufferClose<CR>")
  -- map("", "<leader>bl", "<cmd>BufferOrderByLanguage<CR>")
  -- map("", "<leader>bd", "<cmd>BufferOrderByDirectory<CR>")
  -- map("", "<leader>bd", "<cmd>BufferOrderByDirectory<CR>")
  -- vim.api.nvim_command("BufferOrderByDirectory")
  -- map("", "<A-s>", "<cmd>BufferPick<CR>")
  -- map("t", "<A-s>", "<cmd>BufferPick<CR>")
  -- map("", "<A-1>", "<cmd>BufferGoto 1<cr>")
  -- map("", "<A-2>", "<cmd>BufferGoto 2<cr>")
  -- map("", "<A-3>", "<cmd>BufferGoto 3<cr>")
  -- map("", "<A-4>", "<cmd>BufferGoto 4<cr>")
  -- map("", "<A-5>", "<cmd>BufferGoto 5<cr>")
  -- map("", "<A-6>", "<cmd>BufferGoto 6<cr>")
  -- map("", "<A-7>", "<cmd>BufferGoto 7<cr>")
  -- map("", "<A-8>", "<cmd>BufferGoto 8<cr>")
  -- map("", "<A-9>", "<cmd>BufferGoto 9<cr>")
  -- map("t", "<A-1>", "<cmd>BufferGoto 1<cr>")
  -- map("t", "<A-2>", "<cmd>BufferGoto 2<cr>")
  -- map("t", "<A-3>", "<cmd>BufferGoto 3<cr>")
  -- map("t", "<A-4>", "<cmd>BufferGoto 4<cr>")
  -- map("t", "<A-5>", "<cmd>BufferGoto 5<cr>")
  -- map("t", "<A-6>", "<cmd>BufferGoto 6<cr>")
  -- map("t", "<A-7>", "<cmd>BufferGoto 7<cr>")
  -- map("t", "<A-8>", "<cmd>BufferGoto 8<cr>")
  -- map("t", "<A-9>", "<cmd>BufferGoto 9<cr>")

  -- <cmd>lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>
  -- telescope
  map("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<CR>")
  -- map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<CR>")
  -- map("n", "<leader>.", "<cmd>Goyo!|lua require('telescope.builtin').find_files({find_command={'ls-dots'}, })<CR>")
  map("n", "<leader>ff", "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>")
  map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
  map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>")
  map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<CR>")
  map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>")
  map("n", "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<CR>")
  map("n", "<leader>fl", "<cmd>lua require('telescope.builtin').loclist()<CR>")
  map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').references()<CR>")
  map("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>")
  map("n", "<leader>fA", "<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>")
  map("n", "<leader>ft", "<cmd>lua require('telescope.builtin').treesitter()<CR>")

  -- LSP
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
  map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
  map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  map("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  map("n", "mk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  map("n", "mj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
  map("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
  map("n", "<leader><C-k>", "<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>")

  map("n", "<leader>rg", "<cmd>Rg <cword><cr>")

  -- goyo
  map("n", "<leader>zg", "<cmd>Goyo<CR>")

  -- compe
  map("i", "<C-space>", "compe#complete()", {expr = true})
  map("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
  map("i", "<C-e>", "compe#close('<C-e>')", {expr = true})
  map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {expr = true})
  map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", {expr = true})
  -- compe-autopairs
  map("i", "<CR>", "v:lua.completions()", {expr = true})

  vim.cmd [[
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  ]]
  -- language
  map("", "<leader>le", "<cmd>setlocal spell spelllang=en_us,cjk<cr>")
  map("", "<leader>lf", "<cmd>setlocal spell spelllang=fr,cjk<cr>")
  map("", "<leader>lb", "<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>")
  map("", "<leader>lx", "<cmd>setlocal nospell | spelllang=<cr>")

  --nonotes
  map("", "<C-g>", "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<CR>")
  map("i", "<C-g>", "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<CR>")
  map("", "gzi", "<cmd>lua require'nononotes'.prompt('insert', false, 'all')<CR>")
  map("", "gzn", "<cmd>lua require'nononotes'.new_note()<CR>")
  map("", "gzs", "<cmd>lua require'nononotes'.prompt_step()<CR>")
  map("", "gzS", "<cmd>lua require'nononotes'.new_step()<CR>")
  map("", "gzt", "<cmd>lua require'nononotes'.prompt_thread()<CR>")
  require "nononotes".setup(
    {
      on_ready = function(dir)
        vim.cmd(
          "autocmd BufRead,BufNewFile " .. "*.md nnoremap <buffer> <CR> <cmd>lua require'nonotes'.enter_link()<CR>"
        )
        vim.cmd(
          "autocmd BufRead,BufNewFile " ..
            "/*.md nnoremap <buffer> <C-k> <cmd>lua require'notagain'.print_hover_title()<CR>"
        )
      end
    }
  )

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
end

return {
  setup = setup,
  treesitter = {
    init_selection = "gnn",
    node_incremental = "grn",
    scope_incremental = "grc",
    node_decremental = "grm"
  }
}
