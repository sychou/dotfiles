-- Set leader key to space
-- vim.g.mapleader = ' '

vim.cmd('source ~/.vimrc')

-- vim.cmd('colorscheme lunaperche')
-- Set nvim to transparent background
--vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')

-- General settings
-- local options = {
--     expandtab = true,
--     tabstop = 4,
--     shiftwidth = 4,
--     softtabstop = 4,
--     number = true,
--     relativenumber = true,
--     cursorline = true,
--     mouse = 'a',
--     backup = false,
--     writebackup = false,
--     undofile = true,
--     ignorecase = true,
--     smartcase = true,
--     incsearch = true,
--     hlsearch = true,
--     cmdheight = 2,
--     autoindent = true,
--     smartindent = true,
--     splitright = true,
--     splitbelow = true,
--     updatetime = 300,
--     clipboard = 'unnamedplus'
-- }
--
-- -- Apply each option
-- for k, v in pairs(options) do
--     vim.o[k] = v
-- end
--
-- Lazy package manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin management with lazy.nvim
local plugins = {
    -- Nord
    {
        "gbprod/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nord").setup({})
            vim.cmd.colorscheme("nord")
        end,
        install = {
            colorscheme = { "nord" },
        },
    },
    -- Gruvbox
    { 
        "ellisonleao/gruvbox.nvim", 
        priority = 1000, 
        config = true, 
        opts = {} 
    },
    -- Tokyonight
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
     -- Lualine statusline
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    },
    -- Treesitter for enhanced syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "c", "lua", "vim", "python", "javascript", "html" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = {},
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },
    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        config = function()
            require 'lspconfig'.pyright.setup {}
            require 'lspconfig'.tsserver.setup {}
        end
    },
    -- nvim-cmp for autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-vsnip",
        },
        config = function()
            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-l>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                },
                sources = {
                    { name = 'nvim_lsp' },  -- LSP completions
                    { name = 'vsnip' },     -- Snippet completions
                    { name = 'buffer' },    -- Buffer completions
                    { name = 'path' },      -- File path completions
                }
            }
        end
    },
    -- Telescope for fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
}

require("lazy").setup(plugins, {})

-- Set color scheme
-- vim.cmd[[colorscheme nord]]
-- vim.cmd[[colorscheme gruvbox]]
vim.cmd[[colorscheme tokyonight-night]]

-- Lualine setup
require('lualine').setup {
    options = { 
        -- theme = 'gruvbox' 
        -- theme = 'nord' 
        theme = 'tokyonight' 
    }
}

-- Custom key mappings for Telescope
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', opts)
