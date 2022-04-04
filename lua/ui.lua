local M = {}

-- startup
require("startup").setup({
	header = {
		type = "text",
		oldfiles_directory = false,
		align = "center",
		fold_section = false,
		title = "Header",
		margin = 5,
		content = require("headers").header1,
		highlight = "Statement",
		default_color = "",
		oldfiles_amount = 0,
	},
	-- name which will be displayed and command
	body = {
		type = "mapping",
		oldfiles_directory = false,
		align = "center",
		fold_section = false,
		title = "Basic Commands",
		margin = 5,
		content = {
			{ " Git File", "lua require('ui').project_files()", "<C-p>" },
			{ " Find File", "Telescope find_files", "<leader>ff" },
			{ " Find Word", "Telescope live_grep", "<leader>fg" },
			{ " Recent Files", "Telescope oldfiles", "<leader>of" },
			{ " File Browser", "Telescope file_browser", "<leader>fb" },
			{ " Colorschemes", "Telescope colorscheme", "<leader>cs" },
			{ " New File", "lua require('startup').new_file()", "<leader>nf" },
		},
		highlight = "String",
		default_color = "",
		oldfiles_amount = 0,
	},
	footer = {
		type = "text",
		oldfiles_directory = false,
		align = "center",
		fold_section = false,
		title = "Footer",
		margin = 5,
		content = { "" },
		highlight = "Number",
		default_color = "",
		oldfiles_amount = 0,
	},

	options = {
		mapping_keys = true,
		cursor_column = 0.5,
		empty_lines_between_mappings = true,
		disable_statuslines = true,
		paddings = { 1, 3, 3, 0 },
	},
	mappings = {
		execute_command = "<CR>",
		open_file = "o",
		open_file_split = "<c-o>",
		open_section = "<TAB>",
		open_help = "?",
	},
	colors = {
		background = "#1f2227",
		folded_section = "#56b6c2",
	},
	parts = { "header", "body", "footer" },
})

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
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
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
telescope.load_extension("ui-select")

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

-- dressing
-- default at https://github.com/stevearc/dressing.nvim#configuration
local lspsaga = require("lspsaga")
lspsaga.setup({
	debug = false,
	use_saga_diagnostic_sign = true,
	-- diagnostic sign
	error_sign = "",
	warn_sign = "",
	hint_sign = "",
	infor_sign = "",
	diagnostic_header_icon = "   ",
	-- code action title icon
	code_action_icon = " ",
	code_action_prompt = {
		enable = true,
		sign = true,
		sign_priority = 40,
		virtual_text = true,
	},
	finder_definition_icon = "  ",
	finder_reference_icon = "  ",
	max_preview_lines = 10,
	finder_action_keys = {
		open = "o",
		vsplit = "s",
		split = "i",
		quit = "q",
		scroll_down = "<C-f>",
		scroll_up = "<C-b>",
	},
	code_action_keys = {
		quit = "q",
		exec = "<CR>",
	},
	rename_action_keys = {
		quit = "<C-c>",
		exec = "<CR>",
	},
	definition_preview_icon = "  ",
	border_style = "round", -- single, double, round, bold, plus
	rename_prompt_prefix = "➤",
	rename_output_qflist = {
		enable = false,
		auto_open_qflist = false,
	},
	server_filetype_map = {},
	diagnostic_prefix_format = "%d. ",
	diagnostic_message_format = "%m %c",
	highlight_prefix = false,
})

-- nvim-lightbulb
vim.cmd([[autocmd CursorMoved,CursorMovedI * lua require('nvim-lightbulb').update_lightbulb({})]])
require("nvim-lightbulb").setup({
	-- LSP client names to ignore
	-- Example: {'sumneko_lua', 'null-ls'}
	ignore = {},
	sign = {
		enabled = false,
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
		enabled = true,
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
require("trouble").setup({
	position = "bottom", -- position of the list can be: bottom, top, left, right
	height = 10, -- height of the trouble list when position is top or bottom
	width = 50, -- width of the list when position is left or right
	icons = true, -- use devicons for filenames
	mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
	fold_open = "", -- icon used for open folds
	fold_closed = "", -- icon used for closed folds
	group = true, -- group results by file
	padding = true, -- add an extra new line on top of the list
	action_keys = { -- key mappings for actions in the trouble list
		-- map to {} to remove a mapping, for example:
		-- close = {},
		close = "q", -- close the list
		cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
		refresh = "r", -- manually refresh
		jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
		open_split = { "<c-x>" }, -- open buffer in new split
		open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
		open_tab = { "<c-t>" }, -- open buffer in new tab
		jump_close = { "o" }, -- jump to the diagnostic and close the list
		toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
		toggle_preview = "P", -- toggle auto_preview
		hover = "K", -- opens a small popup with the full multiline message
		preview = "p", -- preview the diagnostic location
		close_folds = { "zM", "zm" }, -- close all folds
		open_folds = { "zR", "zr" }, -- open all folds
		toggle_fold = { "zA", "za" }, -- toggle fold of current file
		previous = "k", -- preview item
		next = "j", -- next item
	},
	indent_lines = true, -- add an indent guide below the fold icons
	auto_open = false, -- automatically open the list when you have diagnostics
	auto_close = false, -- automatically close the list when you have no diagnostics
	auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
	auto_fold = false, -- automatically fold a file trouble list at creation
	auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
	signs = {
		-- icons / text used for a diagnostic
		error = "",
		warning = "",
		hint = "",
		information = "",
		other = "﫠",
	},
	use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
})
vim.cmd([[
nnoremap <leader>xx <cmd>TroubleToggle<CR>
nnoremap <leader>xw <cmd>TroubleToggle lsp_worskpace_diagnostics<CR>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<CR>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<CR>
nnoremap <leader>xl <cmd>TroubleToggle loclist<CR>
nnoremap <leader>xr <cmd>TroubleToggle lsp_references<CR>
]])

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	virtual_text = false,
	signs = true,
	update_in_insert = true,
})

return M
