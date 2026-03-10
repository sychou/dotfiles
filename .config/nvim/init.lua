-- Theme configuration
--     catppuccin
--     catppuccin-latte
--     catppuccin-frappe
--     catppuccin-macchiato
--     catppuccin-mocha
--     gruvbox
--     nord
--     tokyonight
--     tokyonight-night
--     tokyonight-storm
--     tokyonight-day
--     tokyonight-moon
local chosen_theme = "tokyonight-night"

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Theme switching function
function _G.apply_theme(theme)
    local ok, err = pcall(vim.cmd, "colorscheme " .. theme)
    if not ok then
        vim.notify("Failed to load theme '" .. theme .. "': " .. err, vim.log.levels.ERROR)
    end
end

-- Lazy package manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Initialize lazy.nvim with minimal plugins
require("lazy").setup({
    -- Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            apply_theme(chosen_theme)
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto'
                }
            })
        end
    },

    -- Git integration
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",  -- Required for function search
            "crispgm/telescope-heading.nvim",
        },
        config = function()
            require('telescope').load_extension('heading')
        end,
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter').setup {
                ensure_installed = { "c", "lua", "vim", "python", "javascript", "typescript", "html", "rust", "go" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "ts_ls", "rust_analyzer", "gopls" },
            })

            vim.lsp.config("pyright", {})
            vim.lsp.config("ts_ls", {})
            vim.lsp.config("rust_analyzer", {})
            vim.lsp.config("gopls", {})
            vim.lsp.enable({ "pyright", "ts_ls", "rust_analyzer", "gopls" })

            -- Map Ctrl-] to LSP go-to-definition
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                end,
            })
        end,
    },

    -- CSV handling
    {
        'mechatroner/rainbow_csv',
        config = function()
            vim.g.rainbow_csv_delim = ','
        end
    },

    -- Load which-key from separate file
    require("plugins.which-key"),

    -- Add other theme plugins
    { "ellisonleao/gruvbox.nvim" },
    { "nordtheme/vim" },
    { "folke/tokyonight.nvim" },
}, {
    rocks = { enabled = false },
})

-- Basic Neovim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50

-- Keybindings for wrapped line navigation
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set('v', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('v', 'k', 'gk', { noremap = true, silent = true })

-- Create a user command for theme switching
vim.api.nvim_create_user_command('Theme', function(opts)
    apply_theme(opts.args)
end, {
    nargs = 1,
    complete = function()
        return {
            "catppuccin",
            "catppuccin-latte",
            "catppuccin-frappe",
            "catppuccin-macchiato",
            "catppuccin-mocha",
            "gruvbox",
            "nord",
            "tokyonight",
            "tokyonight-night",
            "tokyonight-storm",
            "tokyonight-day",
            "tokyonight-moon",
        }
    end
})
