local format = function()
	-- format everything else first before we fall back to our null-ls
	vim.lsp.buf.formatting_seq_sync({}, 2000, { "null-ls" })
end

local save_format = function(client)
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua require('editor').format()")
	end
end

local on_lsp_attach = function(client)
	lsp_signature.on_attach()
	save_format(client)
end

-- lsp diagnostics ui customization
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	virtual_text = false,
	signs = false,
	update_in_insert = true,
})

-- Enable lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local lspconfig = require("lspconfig")
local lspconfig_util = require("lspconfig/util")

-- Rust config
if vim.fn.executable("cargo") == 1 then
	require("rust-tools").setup({})
	require("rust-tools.inlay_hints").set_inlay_hints()
	require("crates").setup({})
	vim.cmd([[
	autocmd filetype rust nnoremap <silent><leader>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
	autocmd filetype rust nnoremap <silent><leader>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
	autocmd filetype rust nnoremap <silent><leader>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
	autocmd filetype rust nnoremap <silent><leader>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
	autocmd filetype rust nnoremap <silent><leader>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
	]])
end

-- Python config
lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
})

-- Lua config
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.sumneko_lua.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Nix config
lspconfig.rnix.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
})
vim.cmd([[
autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
]])

-- C/C++ config
lspconfig.clangd.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
})

-- Go config
lspconfig.gopls.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
})

-- Zig config
lspconfig.zls.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
})

-- Haskell config
lspconfig.hls.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
	settings = {
		haskell = {
			hlintOn = true,
			formattingProvider = "fourmolu",
		},
	},
})

-- Typescript config
lspconfig.tsserver.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
})

-- eslint config
lspconfig.eslint.setup({
	capabilities = capabilities,
	on_attach = on_lsp_attach,
})

-- Enable null-ls for fallback and unsupported LSPs
local null_ls = require("null-ls")

local null_ls_command_if_exists = function(params)
	return vim.fn.executable(params.command) == 1 and params.command
end

null_ls.setup({
	diagnostics_format = "[#{m}] #{s} (#{c})",
	debounce = 250,
	default_timeout = 5000,
	on_attach = on_lsp_attach,
	sources = {
		-- python
		null_ls.builtins.formatting.autopep8.with({ dynamic_command = null_ls_command_if_exists }),
		null_ls.builtins.diagnostics.flake8.with({ dynamic_command = null_ls_command_if_exists }),

		-- rust
		-- null_ls.builtins.formatting.rustfmt.with({ dynamic_command = null_ls_command_if_exists }),

		-- lua
		null_ls.builtins.formatting.stylua.with({ dynamic_command = null_ls_command_if_exists }),
	},
})

return {
	format = format,
}
