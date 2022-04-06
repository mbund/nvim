-- impatient caches lua vimrc, and requires manually
-- invalidated the cache to reload vimrc
-- require('impatient').enable_profile()

require("config/bufferline")
require("config/colorschemes")
require("config/completion")
require("config/file-browser")
require("config/gitsigns")
require("config/harpoon")
require("config/languages")
require("config/lightbulb")
require("config/lsp_signature")
require("config/lualine")
require("config/rename")
require("config/settings")
require("config/startup")
require("config/telescope")
require("config/treesitter")
require("config/trouble")

-- misc
vim.cmd([[
let g:Hexokinase_highlighters = ['virtual']
]])
