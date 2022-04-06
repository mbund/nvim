local project_files = function()
	local opts = {} -- define here if you want to define something
	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		require("telescope.builtin").find_files(opts)
	end
end

local horizontal_preview_width = function(_, cols, _)
	if cols > 200 then
		return math.floor(cols * 0.7)
	else
		return math.floor(cols * 0.6)
	end
end

local width_for_nopreview = function(_, cols, _)
	if cols > 200 then
		return math.floor(cols * 0.5)
	elseif cols > 110 then
		return math.floor(cols * 0.6)
	else
		return math.floor(cols * 0.75)
	end
end

local height_dropdown_nopreview = function(_, _, rows)
	return math.floor(rows * 0.7)
end

local telescope = require("telescope")
local actions = require("telescope.actions")
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
		lsp_code_actions = {
			theme = "cursor",
			previewer = false,
			layout_config = { width = 0.3, height = 0.4 },
		},
		lsp_definitions = {
			layout_strategy = "horizontal",
			layout_config = { width = 0.95, height = 0.85, preview_width = 0.45 },
		},
		lsp_implementations = {
			layout_strategy = "horizontal",
			layout_config = { width = 0.95, height = 0.85, preview_width = 0.45 },
		},
		lsp_references = {
			layout_strategy = "horizontal",
			layout_config = { width = 0.95, height = 0.85, preview_width = 0.45 },
		},
		buffers = {
			theme = "dropdown",
			previewer = false,
			sort_lastused = true,
			sort_mru = true,
			show_all_buffers = true,
			ignore_current_buffer = true,
			path_display = { shorten = 5 },
			layout_config = {
				width = width_for_nopreview,
				height = height_dropdown_nopreview,
			},
			mappings = {
				n = {
					["dd"] = actions.delete_buffer,
				},
			},
		},
	},
})
telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("ui-select")

local utils = require("config/utils")

utils.map("n", "<C-p>", "<cmd>lua require('config/telescope').project_files() <CR>")
utils.map("n", "<leader>ff", "<cmd> Telescope find_files<CR>")
utils.map("n", "<leader>fg", "<cmd> Telescope live_grep <CR>")
utils.map("n", "<leader>fb", "<cmd> Telescope buffers <CR>")
utils.map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
utils.map("n", "<leader>i", "<cmd> Telescope lsp_references<CR>")
utils.map("n", "<leader>o", "<cmd> Telescope lsp_definitions <CR>")
utils.map("n", "<leader>t", "<cmd> Telescope lsp_type_definitions <CR>")
utils.map("n", "<leader>c", "<cmd> Telescope lsp_code_actions <CR>")
utils.map("n", "<leader>fd", "<cmd> Telescope lsp_document_symbols <CR>")
utils.map("n", "<leader>fw", "<cmd> Telescope lsp_workspace_symbols <CR>")

return {
	project_files = project_files,
}
