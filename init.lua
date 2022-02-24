-- impatient caches lua vimrc, and requires manually
-- invalidated the cache to reload vimrc
-- require('impatient').enable_profile()

require('settings')


require('nvim-autopairs').setup({})

require('lualine').setup({
    options = {
        theme = 'onedark',
        -- disabled_types = { 'NvimTree' },
    },
    sections = {
        lualine_x = {},
    },
})

vim.cmd([[
let g:Hexokinase_highlighters = ['virtual']
]])

-- git
require('gitsigns').setup ({
keymaps = {
  noremap = true,
  ['n <leader>gn'] = { expr = true, "&diff ? \'\' : '<cmd>Gitsigns next_hunk<CR>'"},
  ['n <leader>gp'] = { expr = true, "&diff ? \'\' : '<cmd>Gitsigns prev_hunk<CR>'"},
  ['n <leader>gs'] = '<cmd>Gitsigns stage_hunk<CR>',
  ['v <leader>gs'] = ':Gitsigns stage_hunk<CR>',
  ['n <leader>gu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
  ['n <leader>gr'] = '<cmd>Gitsigns reset_hunk<CR>',
  ['v <leader>gr'] = ':Gitsigns reset_hunk<CR>',
  ['n <leader>gR'] = '<cmd>Gitsigns reset_buffer<CR>',
  ['n <leader>gp'] = '<cmd>Gitsigns preview_hunk<CR>',
  ['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
  ['n <leader>gS'] = '<cmd>Gitsigns stage_buffer<CR>',
  ['n <leader>gU'] = '<cmd>Gitsigns reset_buffer_index<CR>',
  ['n <leader>gts'] = ':Gitsigns toggle_signs<CR>',
  ['n <leader>gtn'] = ':Gitsigns toggle_numhl<CR>',
  ['n <leader>gtl'] = ':Gitsigns toggle_linehl<CR>',
  ['n <leader>gtw'] = ':Gitsigns toggle_word_diff<CR>',
  -- Text objects
  ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
  ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
},
})

-- Telescope & Harpoon
local telescope = require('telescope')
telescope.setup {
  defaults = {
    file_ignore_patterns = { "yarn.lock" }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case"
    },
  },
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      -- theme = "dropdown",
      -- previewer = false,
      mappings = {
        i = {
          ["<M-d>"] = "delete_buffer",
        }
      }
    }
  }
}
telescope.load_extension('fzf')
telescope.load_extension('file_browser')

-- require('harpoon').setup({})

vim.cmd([[
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

nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>, :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>j :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>k :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>d :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>f :lua require("harpoon.ui").nav_file(4)<CR>
]])

-- bufferline
require("bufferline").setup{
  highlights = {
    fill = {
      guibg = "#282828"
    },
    separator_selected = {
      guifg = "#282828"
    },
    separator_visible = {
      guifg = "#282828"
    },
    separator = {
      guifg = "#282828"
    }
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
      return "("..count..")"
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "center"
      }
    }
  }
}

-- nvim-tree
require('nvim-tree').setup({})

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
  TypeParameter = ""
}
local luasnip = require('luasnip')
local cmp = require('cmp')
cmp.setup({
  -- enabled = function()
  --   -- disable completion in comments
  --   local context = require('cmp.config.context')
  --   -- keep command mode completion enabled when cursor is in a comment
  --   if vim.api.nvim_get_mode().mode == 'c' then
  --     return true
  --   else
  --     return not context.in_treesitter_capture("comment") 
  --       and not context.in_syntax_group("Comment")
  -- end,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
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
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'treesitter' },
    { name = 'crates' },
    { name = 'path' },
  },
})

-- lsp
local null_ls = require("null-ls")

local ls_sources = {
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

    -- misc
    null_ls.builtins.code_actions.gitsigns,
}
-- Enable formatting
save_format = function(client)
  if client.resolved_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end
end

default_on_attach = function(client)
  save_format(client)
end

-- Enable null-ls
require('null-ls').setup({
  diagnostics_format = "[#{m}] #{s} (#{c})",
  debounce = 250,
  default_timeout = 5000,
  sources = ls_sources,
  on_attach=default_on_attach
})

-- Enable lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig/util')

-- LSP UI
vim.cmd([[
nnoremap <silent><leader>ca :CodeActionMenu<CR>
]])
require('lsp_signature').setup({})

require("trouble").setup({})
vim.cmd([[
nnoremap <leader>xx <cmd>TroubleToggle<CR>
nnoremap <leader>xw <cmd>TroubleToggle lsp_worskpace_diagnostics<CR>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<CR>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<CR>
nnoremap <leader>xl <cmd>TroubleToggle loclist<CR>
nnoremap <leader>xr <cmd>TroubleToggle lsp_references<CR>
]])

-- Rust config
local rustopts = {
    server = {
      capabilities = capabilities,
      on_attach = default_on_attach,
      settings = {
        ["rust-analyzer"] = {
        experimental = {
          procAttrMacros = true,
        },
      },
      }
    }
}
lspconfig.rust_analyzer.setup({})
require('crates').setup({})
require('rust-tools').setup(rustopts)
require('rust-tools.inlay_hints').set_inlay_hints()
vim.cmd([[
autocmd filetype rust nnoremap <silent><leader>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
autocmd filetype rust nnoremap <silent><leader>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
autocmd filetype rust nnoremap <silent><leader>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
autocmd filetype rust nnoremap <silent><leader>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
autocmd filetype rust nnoremap <silent><leader>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
]])

-- Python config
lspconfig.pyright.setup({
    capabilities = capabilities;
    on_attach = default_on_attach;
})

-- Nix config
lspconfig.rnix.setup({
    capabilities = capabilities;
    on_attach = default_on_attach;
})
vim.cmd([[
autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
]])

-- Clang config
lspconfig.ccls.setup({
    capabilities = capabilities;
    on_attach = default_on_attach;
})

-- Go config
lspconfig.gopls.setup({
    capabilities = capabilities;
    on_attach = default_on_attach;
})

-- Treesitter
require('nvim-treesitter.configs').setup ({
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

require('treesitter-context').setup({
  enable = true,
  throttle = true,
  max_lines = 0
})
