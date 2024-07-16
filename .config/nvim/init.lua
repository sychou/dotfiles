-- init.lua

-- Theme configuration
-- Set this variable to "catppuccin", "gruvbox", "nord", or "tokyonight" to change the theme
-- Catpuccin also supports catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
-- local chosen_theme = "catppuccin-mocha"
local chosen_theme = "tokyonight"

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
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
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
                ignore_install = {},
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        local disabled_filetypes = { "csv", "tsv" }
                        local filetype = vim.bo[buf].filetype
                        return vim.tbl_contains(disabled_filetypes, filetype)
                    end,
                    additional_vim_regex_highlighting = false,
                },
                modules = {},
            }
        end
    },
    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "b0o/schemastore.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "ruff_lsp", "jsonls", "lua_ls" }
            })

            local lspconfig = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Function to set up formatting on save
            local function setup_formatting(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end

            -- Python config
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace"
                        }
                    }
                },
            })

            lspconfig.ruff_lsp.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- Enable formatting
                    client.server_capabilities.documentFormattingProvider = true
                    client.server_capabilities.documentRangeFormattingProvider = true

                    -- Set up formatting on save
                    setup_formatting(client, bufnr)
                end,
            })

            -- JSON configuration
            lspconfig.jsonls.setup({
                capabilities = capabilities,
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    }
                },
                on_attach = function(client, bufnr)
                    setup_formatting(client, bufnr)
                end,
            })

            -- Lua configuration
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    setup_formatting(client, bufnr)
                end,
            })

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    -- vim.keymap.set('n', '<space>wl', function()
                    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    -- end, opts)
                    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                    -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                    -- -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                end,
            })
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
    },
    -- whichkey - https://github.com/folke/which-key.nvim
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            local wk = require("which-key")
            wk.setup({
                -- custom which-key setup
            })
            wk.register({
                f = {
                    name = "Find",
                    f = { "<cmd>Telescope find_files<CR>", "Find File" },
                    g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
                    b = { "<cmd>Telescope buffers<CR>", "Buffers" },
                    h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
                },
                l = {
                    name = "LSP",
                    f = { function() vim.lsp.buf.format({ async = true }) end, "Format" },
                    e = { vim.diagnostic.open_float, "Open Float" },
                    q = { vim.diagnostic.setloclist, "Set Loclist" },
                    D = { vim.lsp.buf.type_definition, "Type Definition" },
                    r = { vim.lsp.buf.rename, "Rename" },
                    a = { vim.lsp.buf.code_action, "Code Action" },
                    w = {
                        name = "Workspace",
                        a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
                        r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
                        l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Folders" },
                    },
                },
                r = {
                    name = "Run",
                    p = { "<cmd>RunPython<CR>", "Run Python" },
                },
                h = {
                    name = "Git Hunk",
                    s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
                    u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk" },
                    r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
                    p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview Hunk" },
                    b = { "<cmd>Gitsigns blame_line<CR>", "Blame Line" },
                },
                ["["] = {
                    c = { "<cmd>Gitsigns prev_hunk<CR>", "Previous Git Hunk" },
                },
                ["]"] = {
                    c = { "<cmd>Gitsigns next_hunk<CR>", "Next Git Hunk" },
                },
                -- g = {
                --     name = "Go to",
                --     D = { vim.lsp.buf.declaration, "Declaration" },
                --     d = { vim.lsp.buf.definition, "Definition" },
                --     i = { vim.lsp.buf.implementation, "Implementation" },
                --     r = { vim.lsp.buf.references, "References" },
                -- },
            }, { prefix = "<leader>" })

            -- Non-leader keymaps
            wk.register({
                gD = { vim.lsp.buf.declaration, "Go to Declaration" },
                gd = { vim.lsp.buf.definition, "Go to Definition" },
                K = { vim.lsp.buf.hover, "Hover Information" },
                gi = { vim.lsp.buf.implementation, "Go to Implementation" },
                ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature Help" },
                ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
                ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
                gr = { vim.lsp.buf.references, "References" },
            })
        end
    },
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
end, {
    nargs = 1,
    complete = function()
        return { "catppuccin", "gruvbox", "nord", "tokyonight" }
    end
})

-- Python script runner setup
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        -- Set up a local key mapping for Python files
        vim.api.nvim_buf_set_keymap(0, 'n', '<F5>', ':w<CR>:split<CR>:terminal python3 %<CR>',
            { noremap = true, silent = true })
    end
})

-- Create a command to run Python scripts
vim.api.nvim_create_user_command('RunPython', function()
    vim.cmd('w')                  -- Save the file
    vim.cmd('split')              -- Split the window
    vim.cmd('terminal python3 %') -- Run the current file in the terminal
end, {})

-- Keymappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Additional keymappings (if any are not covered by which-key)
-- Add any additional keymappings here that are not included in the which-key configuration

-- Note: The following keymappings are now handled by which-key and can be removed:
-- map('n', '<leader>ff', ':Telescope find_files<CR>')
-- map('n', '<leader>fg', ':Telescope live_grep<CR>')
-- map('n', '<leader>fb', ':Telescope buffers<CR>')
-- map('n', '<leader>fh', ':Telescope help_tags<CR>')
-- map('n', ']c', '<cmd>Gitsigns next_hunk<CR>')
-- map('n', '[c', '<cmd>Gitsigns prev_hunk<CR>')
-- map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
-- map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
-- map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
-- map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
-- map('n', '<leader>hb', '<cmd>Gitsigns blame_line<CR>')

-- End of init.lua
