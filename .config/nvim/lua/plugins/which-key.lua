return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function()
        local wk = require("which-key")

        wk.add({
            -- Leader keymaps
            { "<leader>e",   group = "Explore" },
            { "<leader>ee",  "<leader>dd :Lexplore %:p:h<CR>",                                        desc = "Explore Dir of File" },
            { "<leader>ea",  "<leader>dd :Lexplore<CR>",                                              desc = "Explore Current Dir" },

            { "<leader>f",   group = "Find" },
            { "<leader>ff",  "<cmd>Telescope find_files<CR>",                                         desc = "Find File" },
            { "<leader>fg",  "<cmd>Telescope live_grep<CR>",                                          desc = "Live Grep" },
            { "<leader>fb",  "<cmd>Telescope buffers<CR>",                                            desc = "Buffers" },
            { "<leader>fh",  "<cmd>Telescope help_tags<CR>",                                          desc = "Help Tags" },

            { "<leader>l",   group = "LSP" },
            { "<leader>lf",  function() vim.lsp.buf.format({ async = true }) end,                     desc = "Format" },
            { "<leader>le",  vim.diagnostic.open_float,                                               desc = "Open Float" },
            { "<leader>lq",  vim.diagnostic.setloclist,                                               desc = "Set Loclist" },
            { "<leader>ld",  vim.lsp.buf.definition,                                                  desc = "Definition" },
            { "<leader>lD",  vim.lsp.buf.type_definition,                                             desc = "Type Definition" },
            { "<leader>lr",  vim.lsp.buf.rename,                                                      desc = "Rename" },
            { "<leader>la",  vim.lsp.buf.code_action,                                                 desc = "Code Action" },
            { "<leader>ls",  vim.lsp.buf.signature_help,                                              desc = "Signature Help" },
            { "<leader>lw",  { name = "Workspace" } },
            { "<leader>lwa", vim.lsp.buf.add_workspace_folder,                                        desc = "Add Folder" },
            { "<leader>lwr", vim.lsp.buf.remove_workspace_folder,                                     desc = "Remove Folder" },
            { "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "List Folders" },

            { "<leader>r",   group = "Run" },
            { "<leader>rc",  "<cmd>source $MYVIMRC<CR>",                                              desc = "Reload Config" },
            { "<leader>rp",  "<cmd>RunPython<CR>",                                                    desc = "Run Python" },

            { "<leader>G",   group = "Gitsigns" },
            { "<leader>Gs",  "<cmd>Gitsigns stage_hunk<CR>",                                          desc = "Stage Hunk" },
            { "<leader>Gu",  "<cmd>Gitsigns undo_stage_hunk<CR>",                                     desc = "Undo Stage Hunk" },
            { "<leader>Gr",  "<cmd>Gitsigns reset_hunk<CR>",                                          desc = "Reset Hunk" },
            { "<leader>Gp",  "<cmd>Gitsigns preview_hunk<CR>",                                        desc = "Preview Hunk" },
            { "<leader>Gb",  "<cmd>Gitsigns blame_line<CR>",                                          desc = "Blame Line" },
            { "<leader>Ga",  "<cmd>GitAdd<CR>",                                                       desc = "Git Add" },
            { "<leader>Gc",  "<cmd>GitCommit<CR>",                                                    desc = "Git Commit" },
            { "<leader>Gd",  "<cmd>GitDiff<CR>",                                                      desc = "Git Diff" },

            -- Non-leader keymaps
            { "gD",          vim.lsp.buf.declaration,                                                 desc = "Go to Declaration" },
            { "gd",          vim.lsp.buf.definition,                                                  desc = "Go to Definition" },
            { "gi",          vim.lsp.buf.implementation,                                              desc = "Go to Implementation" },
            { "gr",          vim.lsp.buf.references,                                                  desc = "References" },
            { "K",           vim.lsp.buf.hover,                                                       desc = "Hover Information" },
            { "[d",          vim.diagnostic.goto_prev,                                                desc = "Previous Diagnostic" },
            { "]d",          vim.diagnostic.goto_next,                                                desc = "Next Diagnostic" },
            { "[c",          "<cmd>Gitsigns prev_hunk<CR>",                                           desc = "Previous Git Hunk" },
            { "]c",          "<cmd>Gitsigns next_hunk<CR>",                                           desc = "Next Git Hunk" },
        })
    end,
}
