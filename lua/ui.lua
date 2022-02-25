local M = {}

-- bufferline
require("bufferline").setup({
	highlights = {
		fill = {
			guibg = "#282828",
		},
		separator_selected = {
			guifg = "#282828",
		},
		separator_visible = {
			guifg = "#282828",
		},
		separator = {
			guifg = "#282828",
		},
	},
	options = {
		modified_icon = "●",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 25,
		max_prefix_length = 25,
		enforce_regular_tabs = false,
		view = "multiwindow",
		show_buffer_close_icons = true,
		show_close_icon = false,
		separator_style = "slant",
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			return "(" .. count .. ")"
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "center",
			},
		},
	},
})

-- nvim-tree
require("nvim-tree").setup({})

-- Telescope & Harpoon
M.project_files = function()
	local opts = {} -- define here if you want to define something
	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		require("telescope.builtin").find_files(opts)
	end
end

local telescope = require("telescope")
telescope.setup({
	defaults = {
		file_ignore_patterns = { "yarn.lock" },
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = false,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
	pickers = {
		buffers = {
			show_all_buffers = true,
			sort_lastused = true,
			-- theme = 'dropdown',
			-- previewer = false,
			mappings = {
				i = {
					["<M-d>"] = "delete_buffer",
				},
			},
		},
	},
})
telescope.load_extension("fzf")
telescope.load_extension("file_browser")

require("harpoon").setup({})

vim.cmd([[
nnoremap <C-p> <cmd> lua require('ui').project_files()<CR>
nnoremap <leader>ff <cmd> Telescope find_files<CR>
nnoremap <leader>fg <cmd> Telescope live_grep<CR>
nnoremap <leader>fb <cmd> Telescope buffers<CR>
nnoremap <leader>fh <cmd> Telescope help_tags<CR>
nnoremap <leader>fvcw <cmd> Telescope git_commits<CR>
nnoremap <leader>fvcb <cmd> Telescope git_bcommits<CR>
nnoremap <leader>fvb <cmd> Telescope git_branches<CR>
nnoremap <leader>fvs <cmd> Telescope git_status<CR>
nnoremap <leader>fvx <cmd> Telescope git_stash<CR>
nnoremap <leader>ft <cmd> Telescope<CR>
nnoremap <leader>flsb <cmd> Telescope lsp_document_symbols<CR>
nnoremap <leader>flsw <cmd> Telescope lsp_workspace_symbols<CR>
nnoremap <leader>flr <cmd> Telescope lsp_references<CR>
nnoremap <leader>flc <cmd> Telescope lsp_code_actions<CR>
nnoremap <leader>flt <cmd> Telescope lsp_type_definitions<CR>
nnoremap <leader>fldf <cmd> Telescope lsp_definitions<CR>
nnoremap <leader>fldb <cmd> Telescope lsp_document_diagnostics<CR>
nnoremap <leader>fldw <cmd> Telescope lsp_workspace_diagnostics<CR>
nnoremap <leader>fs <cmd> Telescope treesitter

nnoremap <leader>a :lua require('harpoon.mark').add_file()<CR>
nnoremap <leader>, :lua require('harpoon.ui').toggle_quick_menu()<CR>
nnoremap <leader>j :lua require('harpoon.ui').nav_file(1)<CR>
nnoremap <leader>k :lua require('harpoon.ui').nav_file(2)<CR>
nnoremap <leader>d :lua require('harpoon.ui').nav_file(3)<CR>
nnoremap <leader>f :lua require('harpoon.ui').nav_file(4)<CR>
]])

-- code action menu
vim.cmd([[
nnoremap <silent><leader>ca :CodeActionMenu<CR>
]])

-- nvim-lightbulb
require("nvim-lightbulb").setup({
	-- LSP client names to ignore
	-- Example: {'sumneko_lua', 'null-ls'}
	ignore = { "null-ls" },
	sign = {
		enabled = true,
		-- Priority of the gutter sign
		priority = 10,
	},
	float = {
		enabled = false,
		-- Text to show in the popup float
		text = "💡",
		-- Available keys for window options:
		-- - height     of floating window
		-- - width      of floating window
		-- - wrap_at    character to wrap at for computing height
		-- - max_width  maximal width of floating window
		-- - max_height maximal height of floating window
		-- - pad_left   number of columns to pad contents at left
		-- - pad_right  number of columns to pad contents at right
		-- - pad_top    number of lines to pad contents at top
		-- - pad_bottom number of lines to pad contents at bottom
		-- - offset_x   x-axis offset of the floating window
		-- - offset_y   y-axis offset of the floating window
		-- - anchor     corner of float to place at the cursor (NW, NE, SW, SE)
		-- - winblend   transparency of the window (0-100)
		win_opts = {},
	},
	virtual_text = {
		enabled = false,
		-- Text to show at virtual text
		text = "💡",
		-- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
		hl_mode = "replace",
	},
	status_text = {
		enabled = false,
		-- Text to provide when code actions are available
		text = "💡",
		-- Text to provide when no actions are available
		text_unavailable = "",
	},
})

-- LSP signature
require("lsp_signature").setup({})

-- hexinocase
vim.cmd([[
let g:Hexokinase_highlighters = ['virtual']
]])

-- Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
})

require("treesitter-context").setup({
	enable = true,
	throttle = true,
	max_lines = 0,
})

-- gitsigns
local gitsigns = require("gitsigns")
gitsigns.setup({
	keymaps = {
		noremap = true,
		["n <leader>gn"] = { expr = true, "&diff ? '' : '<cmd>Gitsigns next_hunk<CR>'" },
		["n <leader>gp"] = { expr = true, "&diff ? '' : '<cmd>Gitsigns prev_hunk<CR>'" },
		["n <leader>gs"] = "<cmd>Gitsigns stage_hunk<CR>",
		["v <leader>gs"] = ":Gitsigns stage_hunk<CR>",
		["n <leader>gu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",
		["n <leader>gr"] = "<cmd>Gitsigns reset_hunk<CR>",
		["v <leader>gr"] = ":Gitsigns reset_hunk<CR>",
		["n <leader>gR"] = "<cmd>Gitsigns reset_buffer<CR>",
		-- ["n <leader>gp"] = "<cmd>Gitsigns preview_hunk<CR>",
		["n <leader>gb"] = "<cmd>lua gitsigns.blame_line{full=true}<CR>",
		["n <leader>gS"] = "<cmd>Gitsigns stage_buffer<CR>",
		["n <leader>gU"] = "<cmd>Gitsigns reset_buffer_index<CR>",
		["n <leader>gts"] = ":Gitsigns toggle_signs<CR>",
		["n <leader>gtn"] = ":Gitsigns toggle_numhl<CR>",
		["n <leader>gtl"] = ":Gitsigns toggle_linehl<CR>",
		["n <leader>gtw"] = ":Gitsigns toggle_word_diff<CR>",
		-- Text objects
		["o ih"] = ":<C-U>Gitsigns select_hunk<CR>",
		["x ih"] = ":<C-U>Gitsigns select_hunk<CR>",
	},
})

-- lualine
require("lualine").setup({
	options = {
		theme = "onedark",
		-- disabled_types = { 'NvimTree' },
	},
	sections = {
		lualine_x = {},
	},
})

-- trouble
require("trouble").setup({})
vim.cmd([[
nnoremap <leader>xx <cmd>TroubleToggle<CR>
nnoremap <leader>xw <cmd>TroubleToggle lsp_worskpace_diagnostics<CR>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<CR>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<CR>
nnoremap <leader>xl <cmd>TroubleToggle loclist<CR>
nnoremap <leader>xr <cmd>TroubleToggle lsp_references<CR>
]])

return M
