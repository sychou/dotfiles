-- init.lua

-- Theme configuration
-- Set this variable to "catppuccin", "gruvbox", "nord", or "tokyonight" to change the theme
-- Catpuccin also supports catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
local chosen_theme = "catppuccin-mocha"

-- Source .vimrc for backward compatibility
vim.cmd('source ~/.vimrc')

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

-- Plugin definitions
local plugins = {
    -- Color schemes
    {   
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000 
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        opts = {},
    },
    {
        "gbprod/nord.nvim",
        priority = 1000,
        config = function()
            require("nord").setup({})
        end,
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {},
    },
    -- Lualine
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
    },
    -- vim-tmux-navigator
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "c", "lua", "vim", "python", "javascript", "html" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        local disabled_filetypes = { "csv", "tsv" }
                        local filetype = vim.bo[buf].filetype
                        return vim.tbl_contains(disabled_filetypes, filetype)
                    end,
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },
    -- Language server
    {
        "neovim/nvim-lspconfig",
        config = function()
            require('lspconfig').pyright.setup {}
            require('lspconfig').tsserver.setup {}
        end
    },
    -- CMP Autocompletion  
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
            local cmp = require('cmp')
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
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                }
            }
        end
    },
    -- Telescope Fuzzy finder - https://github.com/nvim-telescope/telescope.nvim
    {
        "nvim-telescope/telescope.nvim",
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- GitSigns - https://github.com/lewis6991/gitsigns.nvim
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },
    -- nvim-surround - https://github.com/kylechui/nvim-surround
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    -- rainbow_csv - https://github.com/cameron-wags/rainbow_csv.nvim
    {
        'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        }
    }
}

-- Initialize lazy.nvim
require("lazy").setup(plugins, {})

-- Theme application function
function _G.apply_theme(theme)
    vim.o.background = "dark"
    vim.opt.termguicolors = true
    local colorscheme = theme
    local lualine_theme = theme

    if theme == "tokyonight" then
        colorscheme = "tokyonight-night"
        -- lualine_theme remains "tokyonight"
    end

    vim.cmd("colorscheme " .. colorscheme)

    -- Lualine setup
    require('lualine').setup {
        options = { 
            theme = lualine_theme
        }
    }
end

-- Apply the chosen theme
apply_theme(chosen_theme)

-- Create a user command for easier theme switching
vim.api.nvim_create_user_command('Theme', function(opts)
    apply_theme(opts.args)
end, { nargs = 1, complete = function()
    return { "catppuccin", "gruvbox", "nord", "tokyonight" }
end })

-- Python script runner setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Set up a local key mapping for Python files
    vim.api.nvim_buf_set_keymap(0, 'n', '<F5>', ':w<CR>:split<CR>:terminal python3 %<CR>', { noremap = true, silent = true })
  end
})

-- Create a command to run Python scripts
vim.api.nvim_create_user_command('RunPython', function()
    vim.cmd('w') -- Save the file
    vim.cmd('split') -- Split the window
    vim.cmd('terminal python3 %') -- Run the current file in the terminal
end, {})

-- Add a global keymap for running Python scripts
vim.api.nvim_set_keymap('n', '<leader>rp', ':RunPython<CR>', { noremap = true, silent = true })


-- Keymappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Telescope keymappings
map('n', '<leader>ff', ':Telescope find_files<CR>')
map('n', '<leader>fg', ':Telescope live_grep<CR>')
map('n', '<leader>fb', ':Telescope buffers<CR>')
map('n', '<leader>fh', ':Telescope help_tags<CR>')

-- Gitsigns keymappings
map('n', ']c', '<cmd>Gitsigns next_hunk<CR>')
map('n', '[c', '<cmd>Gitsigns prev_hunk<CR>')
map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
map('n', '<leader>hb', '<cmd>Gitsigns blame_line<CR>')

