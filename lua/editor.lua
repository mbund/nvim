local M = {}

-- Helper functions

M.format = function()
	-- format everything else first before we fall back to our null-ls
	vim.lsp.buf.formatting_seq_sync({}, 2000, { "null-ls" })
end

local save_format = function(client)
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua require('editor').format()")
	end
end

local default_on_attach = function(client)
	save_format(client)
end

-- Enable lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local lspconfig = require("lspconfig")
local lspconfig_util = require("lspconfig/util")

-- Rust config
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

-- Python config
lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
})

-- Lua config
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
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
	on_attach = default_on_attach,
})
vim.cmd([[
autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
]])

-- Clang config
lspconfig.ccls.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
})

-- Go config
lspconfig.gopls.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
})

-- Haskell config
lspconfig.hls.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
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
	on_attach = default_on_attach,
	root_dir = lspconfig_util.root_pattern(".git", "tsconfig.json", "jsconfig.json"),
})

-- Enable null-ls for fallback and unsupported LSPs
local null_ls = require("null-ls")
null_ls.setup({
	diagnostics_format = "[#{m}] #{s} (#{c})",
	debounce = 250,
	default_timeout = 5000,
	on_attach = default_on_attach,
	sources = {
		-- python
		null_ls.builtins.formatting.autopep8,
		null_ls.builtins.diagnostics.flake8,

		-- rust
		null_ls.builtins.formatting.rustfmt,

		-- javascript typescript
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.code_actions.eslint_d,

		-- lua
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.luacheck,

		-- C/C++
		null_ls.builtins.formatting.clang_format,
		null_ls.builtins.diagnostics.cppcheck,
	},
})

-- nvim-cmp
local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local luasnip = require("luasnip")
local cmp = require("cmp")
cmp.setup({
	enabled = function()
		-- disable completion in comments
		local context = require("cmp.config.context")
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			-- Source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[LaTeX]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "treesitter" },
		{ name = "crates" },
		{ name = "path" },
	},
})

return M
