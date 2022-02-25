-- impatient caches lua vimrc, and requires manually
-- invalidated the cache to reload vimrc
-- require('impatient').enable_profile()

require("settings")
require("ui")
require("editor")

require("nvim-autopairs").setup({})
