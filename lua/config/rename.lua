local utils = require("config/utils")

utils.map("n", "<leader>m", "<cmd>lua vim.lsp.buf.rename()<CR>")
utils.map("v", "<leader>m", "<cmd>lua vim.lsp.buf.rename()<CR>")
utils.map("i", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>")
