-- LSP - https://github.com/neovim/nvim-lspconfig
return {
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

        -- Configure LSP diagnostic signs
        vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠", texthl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ", texthl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "➤", texthl = "DiagnosticSignHint" })

        -- Configure diagnostic display
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        -- Show diagnostic message on cursor hover
        vim.o.updatetime = 250
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
            callback = function()
                vim.diagnostic.open_float(nil, { focus = false })
            end
        })

        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Function to set up formatting on save
        local function setup_formatting(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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
            end,
        })
    end
}
