require("harpoon").setup({
	-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
	save_on_toggle = false,

	-- saves the harpoon file upon every change. disabling is unrecommended.
	save_on_change = true,

	-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
	enter_on_sendcmd = false,

	-- closes any tmux windows harpoon that harpoon creates when you close Neovim.
	tmux_autoclose_windows = false,

	-- filetypes that you want to prevent from adding to the harpoon list menu.
	excluded_filetypes = { "harpoon" },

	-- set marks specific to each git branch inside git repository
	mark_branch = false,
})

local utils = require("config/utils")

utils.map("n", "<A-g>", "<cmd>lua require('harpoon.mark').add_file()<CR>")
utils.map("n", "<A-h>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>")
utils.map("n", "<A-j>", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>")
utils.map("n", "<A-k>", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>")
utils.map("n", "<A-f>", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>")
utils.map("n", "<A-d>", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>")
