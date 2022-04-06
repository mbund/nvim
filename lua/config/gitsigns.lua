local gitsigns = require("gitsigns")
gitsigns.setup({
	keymaps = {
		noremap = true,
		["n <leader>gs"] = "<cmd>Gitsigns stage_hunk<CR>",
		["n <leader>gu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",
		["n <leader>gR"] = "<cmd>Gitsigns reset_hunk<CR>",
		["n <leader>gb"] = "<cmd>lua require('gitsigns').blame_line{full=true}<CR>",
		["n <leader>gw"] = "<cmd>Gitsigns toggle_word_diff<CR>",
		-- Text objects
		["o ih"] = ": <C-U>Gitsigns select_hunk<CR>",
		["x ih"] = ": <C-U>Gitsigns select_hunk<CR>",
	},
})
