local utils = require('utils')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = '~/.vim/undodir'
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes:1"
vim.opt.encoding = 'UTF-8'
vim.opt.termguicolors = true

vim.cmd('colorscheme onedark')
vim.cmd('set guicursor=')
vim.cmd([[
set listchars=tab:▸\ ,trail:·,precedes:←,extends:→,eol:↲,nbsp:␣
autocmd InsertEnter * set list
autocmd VimEnter,BufEnter,InsertLeave * set nolist
]])

vim.g.mapleader = ' '

vim.cmd([[
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap Y yg$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

xnoremap <leader>p "_dP

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nmap <leader>Y "+Y

" Escape terminal mode
tnoremap <Esc> <C-\><C-n>

" resize current buffer by +/- 5 
nnoremap <M-Right> :vertical resize -5<cr>
nnoremap <M-Up> :resize +5<cr>
nnoremap <M-Down> :resize -5<cr>
nnoremap <M-Left> :vertical resize +5<cr>

nnoremap <leader>/ :Commentary<CR>
vnoremap <leader>/ :Commentary<CR>
]])
