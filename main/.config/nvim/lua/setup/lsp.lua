local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
	if err ~= nil or result == nil then
		return
	end
	if not vim.api.nvim_buf_get_option(bufnr, "modified") then
		local view = vim.fn.winsaveview()
		vim.lsp.util.apply_text_edits(result, bufnr)
		vim.fn.winrestview(view)
		if bufnr == vim.api.nvim_get_current_buf() then
			vim.api.nvim_command("noautocmd :update")
		end
	end
end

local mode = ""
do
	local method = "textDocument/publishDiagnostics"
	local default_handler = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
		default_handler(err, method, result, client_id, bufnr, config)
		if mode == "lsp_diagnostic" then
			local diagnostics = vim.lsp.diagnostic.get_all()
			local qflist = {}
			for bufnr, diagnostic in pairs(diagnostics) do
				for _, d in ipairs(diagnostic) do
					d.bufnr = bufnr
					d.lnum = d.range.start.line + 1
					d.col = d.range.start.character + 1
					d.text = d.message
					table.insert(qflist, d)
				end
			end
			vim.lsp.util.set_qflist(qflist)
		end
	end
end

local nvim_lsp = require("lspconfig")

local function on_attach_efm(client, bufnr)
	client.resolved_capabilities.document_formatting = true
	client.resolved_capabilities.goto_definition = false
	vim.api.nvim_command([[augroup Format]])
	vim.api.nvim_command([[autocmd! * <buffer>]])
	vim.api.nvim_command([[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]])
	vim.api.nvim_command([[augroup END]])
end

local function on_attach(client, bufnr)
	-- vim.api.nvim_buf_set_keymap(bufnr, ...)
	-- vim.api.nvim_buf_set_option(bufnr, ...)
	-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	client.resolved_capabilities.document_formatting = false
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
			false
		)
	end
end

local servers = {
	"bashls",
	"cssls",
	"html",
	"jsonls",
	"vimls",
	"yamlls",
	"pyls",
	"tsserver",
}

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 500,
			allow_incremental_sync = true,
		},
	})
end

nvim_lsp.sumneko_lua.setup(require("lua-dev").setup({
	lspconfig = {
		cmd = { "lua-language-server" },
		-- on_attach = on_attach,
		settings = {
			Lua = {
				diagnostics = {
					globals = {
						"use", -- packer
						"xplr", -- xplr
					},
				},
			},
		},
	},
}))

local prettier = {
	formatcommand = ([[
      prettier
      ${--config-precedence:configprecedence}
      ${--tab-width:tabwidth}
      ${--single-quote:singlequote}
      ${--trailing-comma:trailingcomma}
  ]]):gsub("\n", ""),
}

local eslint = {
	lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
	formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
	formatStdin = true,
}

local stylua = {
	formatcommand = "stylua -",
	formatStdin = true,
}

local vint = {
	lintCommand = "vint -",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
}

local rustfmt = {
	formatCommand = "rustfmt --emit=stdout",
	formatStdin = true,
}

local shellcheck = {
	lintCommand = "shellcheck -f gcc -x -",
	lintStdin = true,
	lintFormats = { "%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m" },
}

local shfmt = {
	formatCommand = "shfmt -ci -s -bn",
	formatStdin = true,
}

nvim_lsp.efm.setup({
	on_attach = on_attach_efm,
	init_options = { documentFormatting = true },
	settings = {
		languages = {
			vim = { vint },
			lua = { stylua },
			typescript = { prettier, eslint },
			javascript = { prettier, eslint },
			typescriptreact = { prettier, eslint },
			javascriptreact = { prettier, eslint },
			yaml = { prettier },
			json = { prettier },
			html = { prettier },
			scss = { prettier },
			css = { prettier },
			markdown = { prettier },
			sh = { shfmt, shellcheck },
			toml = { prettier },
		},
	},
})


-- does not work with jsx/tsx, will keep using emmet.vim
-- local configs = require("lspconfig/configs")
-- if not nvim_lsp.emmet_ls then
-- 	configs.emmet_ls = {
-- 		default_config = {
-- 			cmd = { "emmet-ls", "--stdio" },
-- 			filetypes = { "html", "css" },
-- 			root_dir = function(fname)
-- 				return vim.loop.cwd()
-- 			end,
-- 		},
-- 	}
-- end
-- nvim_lsp.emmet_ls.setup({ capabilities = capabilities })
