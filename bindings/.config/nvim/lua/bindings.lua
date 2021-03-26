local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function setup()
  vim.g.mapleader = " "
  vim.g.user_emmet_leader_key = "<C-y>"

  map("", "<C-l>", "<cmd>noh<CR>") -- Clear highlights
  map("i", "<C-l>", "<cmd>noh<CR>") -- Clear highlights
  map("", "<C-s>", "<Esc>:w<CR>")
  map("i", "<C-s>", "<Esc>:w<CR>")
  map("", "<C-n>", "<cmd>tabe<CR>")
  map("i", "<C-n>", "<cmd>tabe<CR>")
  map("t", "<C-w>", "<C-\\><C-n>")
  map("", "<C-x>", "<cmd>up|bd!<CR>")
  map("i", "<C-x>", "<cmd>up|bd!<CR>")
  map("", "<C-w>L", "<cmd>vsplit<CR>")
  map("", "<C-w>J", "<cmd>hsplit<CR>")
  -- bufferline

  map("", "<S-j>", "<cmd>BufferLineCycleNext<CR>")
  map("", "<S-k>", "<cmd>BufferLineCyclePrev<CR>")
  map("", "<leader>be", "<cmd>BufferLineSortByExtension<CR>")
  map("", "<leader>bd", "<cmd>BufferLineSortByDirectory<CR>")
  map("", "<leader>gb", "<cmd>BufferLinePick<CR>")
  -- <cmd>BufferLineMoveNext<CR>
  -- <cmd>BufferLineMovePrev<CR>
  -- <cmd>lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>
  -- telescope
  map("n", "<C-p>", "<cmd>Goyo!|lua require('telescope.builtin').find_files({hidden = true})<CR>")
  map("n", "<leader>ff", "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>")
  map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
  map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<CR>")
  map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>")
  map("n", "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<CR>")
  map("n", "<leader>fl", "<cmd>lua require('telescope.builtin').loclist()<CR>")
  map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').references()<CR>")
  map("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>")
  map("n", "<leader>fA", "<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>")
  map("n", "<leader>ft", "<cmd>lua require('telescope.builtin').treesitter()<CR>")
  --  map("n", "<leader>fp", "<cmd>lua require('telescope').extensions.project.project{}<CR>")

  -- LSP
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "<C-i>", "<cmd>lua vim.lsp.buf.hover()<CR>")
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

  -- goyo
  map("n", "<leader>zg", "<cmd>Goyo<CR>")

  -- format
  map("n", "<leader>=", "<cmd>Format<CR>")

  -- compe
  map("i", "<C-space>", "compe#complete()", {expr = true})
  map("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
  map("i", "<C-e>", "compe#close('<C-e>')", {expr = true})
  map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {expr = true})
  map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", {expr = true})
  -- compe-autopairs
  map("i", "<CR>", "v:lua.completions()", {expr = true})
  -- neuron
  -- mapping generation doesn't seen to work propersly
  --[[

    - <CR>: follow link
    - n: new note
    - z: open note
    - Z: insert note i
    - b: open note form backlinks
    - B: insert note from backlinks
    - t: insert tag
    - s: start server (port 8200)
    - : next extmark
    - : previous extmark

  ]]
  map("n", "<CR>", "<cmd>lua require'neuron'.enter_link()<CR>")
  map("n", "gzn", "<cmd>lua require'neuron/cmd'.new_edit(require'neuron'.config.neuron_dir)<CR>")
  map("n", "<C-g>", "<cmd>lua require'neuron/telescope'.find_zettels()<CR>")
  map("n", "gzi", "<cmd>lua require'neuron/telescope'.find_zettels {insert = true}<CR>")
  map("n", "gzb", "<cmd>lua require'neuron/telescope'.find_backlinks()<CR>")
  map("n", "gzB", "<cmd>lua require'neuron/telescope'.find_backlinks {insert = true}<CR>")
  map("n", "gzt", "<cmd>lua require'neuron/telescope'.find_tags()<CR>")
  map("n", "gzs", "<cmd>lua require'neuron'.rib {address = '127.0.0.1:8200', verbose = true}<CR>")
  -- <cmd>lua require"neuron".goto_next_extmark()<CR>
  -- <cmd>lua require"neuron".goto_prev_extmark()<CR>
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

--[[
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

--]]
-- Set some keybinds conditional on server capabilities
--  if client.resolved_capabilities.document_formatting then
--    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
-- elseif client.resolved_capabilities.document_range_formatting then
--  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
--end
