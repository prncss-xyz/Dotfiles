local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local prefix = "<leader>b"

-- TODO, help, Cheat
local function mkSearch(abbr, help, url)
	map("n", prefix .. abbr, string.format("<cmd>BrowserSearchCword %s<cr>", url))
	map("v", prefix .. abbr, string.format("<cmd>BrowserSearchVisualSelection %s<cr>", url))
end

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col(".") - 1
	if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
		return true
	else
		return false
	end
end

local ls = require("luasnip")
-- local ls = require("snippets")

local function preview_location_callback(_, _, result)
	if result == nil or vim.tbl_isempty(result) then
		return nil
	end
	vim.lsp.util.preview_location(result[1])
end

_G.PeekDefinition = function()
	local params = vim.lsp.util.make_position_params()
	return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end
_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t("<C-n>")
	elseif ls.jumpable(1) == true then
		-- return t("<cmd>lua require'snippets'.expand_or_advance(1)<Cr>")
		return t("<cmd>lua require'luasnip'.expand_or_jump(1)<Cr>")
	elseif check_back_space() then
		return t("<Tab>")
	else
		return t("<cmd>call emmet#moveNextPrev(1)<cr>")
		-- return vim.fn["compe#complete"]()
	end
end

_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t("<C-p>")
	elseif ls.jumpable() == true then
		-- return t("<cmd>lua require'snippets'.expand_or_advance(-1)<Cr>")
		return t("<cmd>lua require'luasnip'.expand_or_jump(-1)<Cr>")
	else
		-- If <S-Tab> is not working in your terminal, change it to <C-h>
		-- return t("<cmd>call emmet#moveNextPrev(0)<cr>")
		return t("<S-Tab>")
	end
end

local function setup()
	vim.g.mapleader = " "
	vim.g.user_emmet_leader_key = "<C-y>"

	-- lightspeed: canceling "f" until it works better
	map("", "f", "f")
	map("", "F", "F")
	map("", "t", "t")
	map("", "T", "T")

	-- asterisk
	map("", "*", "<Plug>(asterisk-*)", { noremap = false })
	map("", "#", "<Plug>(asterisk-#)", { noremap = false })
	map("i", "*", "<Plug>(asterisk-*)", { noremap = false })
	map("i", "#", "<Plug>(asterisk-#)", { noremap = false })
	map("", "g*", "<Plug>(asterisk-g*)", { noremap = false })
	map("", "g#", "<Plug>(asterisk-g#)", { noremap = false })

	-- cutlass
	map("n", "x", "d")
	map("x", "x", "d")
	map("n", "xx", "dd")
	map("n", "X", "D")
	map("v", "p", '"_dp')
	map("v", "P", '"_dP')
	map("n", "<c-v>", "p")
	map("v", "<c-v>", "dp")
	map("i", "<c-v>", "<esc>pa")
	-- map("", "<c-z>", "u")
	-- map("i", "<c-z>", "<esc>ui")
	-- map("", "<c-c-z>", "<C-R>")
	-- map("i", "<c-s-z>", "<C-R>")
	-- map("v", "<c-c>", '"+y')
	-- map("v", "<c-x>", '"+d')
	map("", "<m-v>", "<c-v>")
	-- map("", "<C-l>", "<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-l>") -- Clear highlights
	map("", "<C-l>", ":noh<cr>")
	map("i", "<C-l>", "<Esc>:noh<cr>")
	map("", "<c-s>", "<Esc>:w!<CR>")
	map("i", "<c-s>", "<Esc>:w!<CR>")
	map("t", "<c-w>", "<C-\\><C-n>")
	map("", "<C-w>L", "<cmd>vsplit<CR>")
	map("", "<C-w>J", "<cmd>split<CR>")
	map("c", "<C-n>", "<down>")
	map("c", "<C-p>", "<up>")
	map("", "gx", '<Cmd>call jobstart(["opener", expand("<cfile>")], {"detach": v:true})<CR>')
	map("", "<F2>", "<cmd>ToggleQuickFix<cr>")
	-- from https://github.com/mhinz/vim-galore
	-- The mapping takes a register (or * by default) and opens it in the cmdline-window. Hit <cr> when you're done editing for setting the register.
	-- Use it like this <leader>m or "q<leader>m.
	-- Notice the use of <c-r><c-r> to make sure that the <c-r> is inserted literally. See :h c_^R^R.

	-- map('', '<C-h>', '<cmd>HopChar2<cr>')

	map("n", "<leader>m", ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>")

	-- map('', '<c-n>', ':edit %:h/')
	-- map('i', '<c-n>', '<esc>:edit %:h/')

	-- map("", "<c-w>x", "<cmd>Bdelete!<CR>")
	-- map("", "<c-w><c-x>", "<cmd>bdelete!<CR>")

	-- bufferline
	-- map('', '<c-w><s-x>', '<cmd>BufferLineCloseRight<CR><cmd>BufferLineCloseLeft<CR>')
	-- map('', '<S-j>', '<cmd>BufferLineCycleNext<CR>')
	-- map('', '<S-k>', '<cmd>BufferLineCyclePrev<CR>')
	-- map('', '<A-S-j>', '<cmd>BufferLineMoveNext<CR>')
	-- map('', '<A-S-k>', '<cmd>BufferLineMovePrev<CR>')
	-- map('', '<leader>be', '<cmd>BufferLineSortByExtension<CR>')
	-- map('', '<leader>bd', '<cmd>BufferLineSortByDirectory<CR>')
	-- map('', '<A-s>', '<cmd>BufferLinePick<CR>')
	-- map('', '<A-1>', "<cmd>lua require'bufferline'.go_to_buffer(1)<cr>")
	-- map('', '<A-2>', "<cmd>lua require'bufferline'.go_to_buffer(2)<cr>")
	-- map('', '<A-3>', "<cmd>lua require'bufferline'.go_to_buffer(3)<cr>")
	-- map('', '<A-4>', "<cmd>lua require'bufferline'.go_to_buffer(4)<cr>")
	-- map('', '<A-5>', "<cmd>lua require'bufferline'.go_to_buffer(5)<cr>")
	-- map('', '<A-6>', "<cmd>lua require'bufferline'.go_to_buffer(6)<cr>")
	-- map('', '<A-7>', "<cmd>lua require'bufferline'.go_to_buffer(7)<cr>")
	-- map('', '<A-8>', "<cmd>lua require'bufferline'.go_to_buffer(8)<cr>")
	-- map('', '<A-9>', "<cmd>lua require'bufferline'.go_to_buffer(9)<cr>")
	-- map('t', '<A-1>', "<cmd>lua require'bufferline'.go_to_buffer(1)<cr>")
	-- map('t', '<A-2>', "<cmd>lua require'bufferline'.go_to_buffer(2)<cr>")
	-- map('t', '<A-3>', "<cmd>lua require'bufferline'.go_to_buffer(3)<cr>")
	-- map('t', '<A-4>', "<cmd>lua require'bufferline'.go_to_buffer(4)<cr>")
	-- map('t', '<A-5>', "<cmd>lua require'bufferline'.go_to_buffer(5)<cr>")
	-- map('t', '<A-6>', "<cmd>lua require'bufferline'.go_to_buffer(6)<cr>")
	-- map('t', '<A-7>', "<cmd>lua require'bufferline'.go_to_buffer(7)<cr>")
	-- map('t', '<A-8>', "<cmd>lua require'bufferline'.go_to_buffer(8)<cr>")
	-- map('t', '<A-9>', "<cmd>lua require'bufferline'.go_to_buffer(9)<cr>")

	-- barbar
	map("", "<A-r>", "<cmd>BufferNext<CR>")
	map("", "<A-e>", "<cmd>BufferPrevious<CR>")
	map("i", "<A-r>", "<cmd>BufferNext<CR>")
	map("i", "<A-e>", "<cmd>BufferPrevious<CR>")
	map("", "<A-S-r>", "<cmd>BufferMoveNext<CR>")
	map("", "<A-S-e>", "<cmd>BufferMovePrevious<CR>")
	map("", "<a-c>", "<cmd>BufferClose!<CR>")
	map("", "<leader>bl", "<cmd>BufferOrderByLanguage<CR>")
	map("", "<leader>bd", "<cmd>BufferOrderByDirectory<CR>")
	map("", "<leader>bd", "<cmd>BufferOrderByDirectory<CR>")
	map("", "<A-1>", "<cmd>BufferGoto 1<cr>")
	map("", "<A-2>", "<cmd>BufferGoto 2<cr>")
	map("", "<A-3>", "<cmd>BufferGoto 3<cr>")
	map("", "<A-4>", "<cmd>BufferGoto 4<cr>")
	map("", "<A-5>", "<cmd>BufferGoto 5<cr>")
	map("", "<A-6>", "<cmd>BufferGoto 6<cr>")
	map("", "<A-7>", "<cmd>BufferGoto 7<cr>")
	map("", "<A-8>", "<cmd>BufferGoto 8<cr>")
	map("", "<A-9>", "<cmd>BufferGoto 9<cr>")
	map("i", "<A-1>", "<cmd>BufferGoto 1<cr>")
	map("i", "<A-2>", "<cmd>BufferGoto 2<cr>")
	map("i", "<A-3>", "<cmd>BufferGoto 3<cr>")
	map("i", "<A-4>", "<cmd>BufferGoto 4<cr>")
	map("i", "<A-5>", "<cmd>BufferGoto 5<cr>")
	map("i", "<A-6>", "<cmd>BufferGoto 6<cr>")
	map("i", "<A-7>", "<cmd>BufferGoto 7<cr>")
	map("i", "<A-8>", "<cmd>BufferGoto 8<cr>")
	map("i", "<A-9>", "<cmd>BufferGoto 9<cr>")
	map("t", "<A-1>", "<cmd>BufferGoto 1<cr>")
	map("t", "<A-2>", "<cmd>BufferGoto 2<cr>")
	map("t", "<A-3>", "<cmd>BufferGoto 3<cr>")
	map("t", "<A-4>", "<cmd>BufferGoto 4<cr>")
	map("t", "<A-5>", "<cmd>BufferGoto 5<cr>")
	map("t", "<A-6>", "<cmd>BufferGoto 6<cr>")
	map("t", "<A-7>", "<cmd>BufferGoto 7<cr>")
	map("t", "<A-8>", "<cmd>BufferGoto 8<cr>")
	map("t", "<A-9>", "<cmd>BufferGoto 9<cr>")

	-- <cmd>lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>
	-- finder: telescope
	map("n", "<leader> ", "<cmd>lua Project_files()<CR>")
	-- map('n', '<c-space>', "<cmd>lua require('telescope.builtin').git_files()<CR>")
	map("n", "<leader>.", "<cmd>lua require('telescope.builtin').find_files({find_command={'ls-dots'}, })<CR>")
	map("n", "<leader>;", "<cmd>lua require('telescope.builtin').commands()<CR>")
	map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
	map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>")
	map("n", "<leader>?", "<cmd>lua require('telescope.builtin').help_tags()<CR>")
	map("n", "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<CR>")
	map("n", "<leader>fl", "<cmd>lua require('telescope.builtin').loclist()<CR>")
	map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>")
	map("n", "<leader>/", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")

	map("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>")
	map("n", "<leader>fA", "<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>")
	map("n", "<leader>ft", "<cmd>lua require('telescope.builtin').treesitter()<CR>")
	map("n", "<leader>fp", "<cmd>SearchSession<CR>")
	map("n", "<leader>fs", "<cmd>Telescope symbols<cr>")
	map("n", "<leader>fc", "<cmd>Cheatsheet<cr>")
	map("n", "<leader>fh", "<cmd>Telescope heading<cr>")

	-- LSP
	-- -- movements
	map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	map("n", "gm", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
	map("n", "gM", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
	-- -- hovering
	map("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	map("n", "<leader>ld", "<cmd>lua PeekDefinition()<CR>")
	map("n", "<leader>lk", "<cmd>lua vim.lsp.buf.hover()<CR>")
	map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	map("n", "<leader>lm", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
	-- -- workspace actions
	map("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	map("n", "<leader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	map("n", "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
	map("", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")
	map("", "<leader>lx", "<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>")
	-- -- quicklist/loclist
	map("", "<leader>lq", "<cmd>lua vim.lsp.buf.references()<CR>")
	map("", "<leader>ll", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
	map("", "<leader>l@", "<cmd>ProDoc<cr>")
	map("", "<leader>lo", "<cmd>SymbolsOutline<cr>")

	map("", "<leader>l?", "<cmd>CheatDetect<cr>")

	map("", "<leader>*", "<cmd>Rg <cword><cr>")
	-- zen mode
	map("", "<leader>zz", "<cmd>ZenMode<CR>")

	-- compe
	map("i", "<c-space>", "compe#complete()", { expr = true })
	-- map("i", "<CR>", "compe#confirm('<CR>')", { expr = true })
	map("i", "<C-e>", "compe#close('<C-e>')", { expr = true })
	map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { expr = true })
	map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { expr = true })

	-- spell
	map("", "<leader>se", "<cmd>setlocal spell spelllang=en_us,cjk<cr>")
	map("", "<leader>sf", "<cmd>setlocal spell spelllang=fr,cjk<cr>")
	map("", "<leader>sb", "<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>")
	map("", "<leader>sx", "<cmd>setlocal nospell | spelllang=<cr>")
	map("", "<leader>sg", "<cmd>LanguageToolCheck<cr>")

	-- nonotes
	map("", "<C-g>", "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<CR>")
	map("i", "<C-g>", "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<CR>")
	map("", "<leader>ni", "<cmd>lua require'nononotes'.prompt('insert', false, 'all')<CR>")
	map("", "<leader>nn", "<cmd>lua require'nononotes'.new_note()<CR>")
	map("", "<leader>ns", "<cmd>lua require'nononotes'.prompt_step()<CR>")
	map("", "<leader>nS", "<cmd>lua require'nononotes'.new_step()<CR>")
	map("", "<leader>nt", "<cmd>lua require'nononotes'.prompt_thread()<CR>")

	require("nononotes").setup({
		on_ready = function(dir)
			vim.cmd(
				"autocmd BufRead,BufNewFile "
					.. "*.md nnoremap <buffer> <CR> <cmd>lua require'nonotes'.enter_link()<CR>"
			)
			vim.cmd(
				"autocmd BufRead,BufNewFile "
					.. "/*.md nnoremap <buffer> <C-k> <cmd>lua require'notagain'.print_hover_title()<CR>"
			)
		end,
	})

	-- map('', 'n', "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>)")
	-- map('', 'N', "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>)")
	-- map('', '*', "*<Cmd>lua require('hlslens').start()<CR>")
	-- map('', '#', "#<Cmd>lua require('hlslens').start()<CR>")
	-- map('', 'g*', "g*<Cmd>lua require('hlslens').start()<CR>")
	-- map('', 'g#', "g#<Cmd>lua require('hlslens').start()<CR>")

	map("i", "<Tab>", "v:lua.tab_complete()", { expr = true, silent = true })
	map("s", "<Tab>", "v:lua.tab_complete()", { expr = true, silent = true })
	map("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true, silent = true })
	map("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true, silent = true })

	-- dap
	map("", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
	map("", "<leader>dB", "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<cr>")
	map("", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
	map("", "<leader>ds", "<cmd>lua require'dap'.stop()<cr>")
	map("", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>")
	map("", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>")
	map("", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>")
	map("", "<leader>d.", "<cmd>lua require'dap'.run_last()<cr>")
	map("", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>")

	map("", "<leader>dk", "<cmd>lua require'dap'.up()<cr>")
	map("", "<leader>dj", "<cmd>lua require'dap'.down()<cr>")

	map("", "<leader>dl", "<cmd>lua require'setup.dap'.launch()<cr>")
	map("", "<leader>dr", "<cmd>lua require'dap'.repl.open()<cr>")
	map("", "<leader>da", "<cmd>lua require'setup/dap'.attach()<cr>")
	map("", "<leader>dA", "<cmd>lua require'setup/dap'.attachToRemote()<cr>")

	map("", "<leader>dtc", "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>")
	map("", "<leader>dt,", "<cmd>lua require'telescope'.extensions.dap.configurations{}<cr>")
	map("", "<leader>dtb", "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>")
	map("", "<leader>dtv", "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>")
	map("", "<leader>dtf", "<cmd>lua require'telescope'.extensions.dap.frames{}<cr>")

	map("", "<leader>dh", "<cmd>lua require'dap.ui.widgets'.hover()<CR>")
	map("", "<leader>dH", "<cmd>lua require'dap.ui.variables'.hover()<CR>")
	map("", "<leader>dv", "<cmd>lua require'dap.ui.variables'.visual_hover()<CR>")
	map("", "<leader>d?", "<cmd>lua require'dap.ui.variables'.scopes()<CR>")

	-- sandwich
	map("", "<leader>p", "<Plug>(operator-sandwich-add)", { noremap = false })
	map("", "<leader>c", "<Plug>(operator-sandwich-delete)", { noremap = false })
	map("", "<leader>r", "<Plug>(operator-sandwich-replace)", { noremap = false })

	-- xplr
	map("", "<leader>xx", "<cmd>XplrPicker %:p<cr>")

	mkSearch("go", "google", "https://google.ca/search?q=")
	mkSearch("d", "duckduckgo", "https://duckduckgo.com/?q=")
	mkSearch("y", "youtube", "https://www.youtube.com/results?search_query=")

	mkSearch("gh", "github", "https://github.com/search?q=")
	mkSearch("npm", "npm", "https://www.npmjs.com/search?q=")
	mkSearch("lh", "libhunt", "https://www.libhunt.com/search?query=")
	mkSearch("mdn", "mdn", "https://developer.mozilla.org/en-US/search?q=")
	mkSearch("arch", "archlinux wiki", "https://wiki.archlinux.org/index.php?search=")
	mkSearch("pac", "arch packages", "https://archlinux.org/packages/?q=")
	mkSearch("aur", "aur packages", "https://aur.archlinux.org/packages/?K=")

	mkSearch("sea", "seriouseats", "https://www.seriouseats.com/search?q=")
	mkSearch("nell", "nelligan", "https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=")

	mkSearch("p", "persée", "https://www.persee.fr/search?ta=article&q=")
	mkSearch("sep", "sep", "https://plato.stanford.edu/search/searcher.py?query=")
	mkSearch("c", "cairn", "https://www.cairn.info/resultats_recherche.php?searchTerm=")
	mkSearch("fr", "francis", "https://pascal-francis.inist.fr/vibad/index.php?action=search&terms=")
	mkSearch("eru", "erudit", "https://www.erudit.org/fr/recherche/?funds=%C3%89rudit&funds=UNB&basic_search_term=")

	mkSearch("c", "cnrtl", "https://www.cnrtl.fr/definition/")
	mkSearch("usi", "usito", "https://usito.usherbrooke.ca/d%C3%A9finitions/")
	map("n", prefix .. "gr", "<cmd>BrowserSearchGh<cr>")
end

return {
	setup = setup,
	treesitter = {
		init_selection = "gnn",
		node_incremental = "grn",
		scope_incremental = "grc",
		node_decremental = "grm",
	},
}
