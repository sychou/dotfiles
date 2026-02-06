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
            { "<leader>?",   "<cmd>WhichKey<CR>",                                                      desc = "Show Keymaps" },
            { "<leader>e",   group = "Explore" },
            { "<leader>ee",  "<cmd>Lexplore %:p:h<CR>",                                               desc = "Explore Dir of File" },
            { "<leader>ea",  "<cmd>Lexplore<CR>",                                                     desc = "Explore Current Dir" },

            { "<leader>f",   group = "Find" },
            { "<leader>ff",  "<cmd>Telescope find_files<CR>",                                         desc = "Find File" },
            { "<leader>fg",  "<cmd>Telescope live_grep<CR>",                                          desc = "Live Grep" },
            { "<leader>fb",  "<cmd>Telescope buffers<CR>",                                            desc = "Buffers" },
            { "<leader>fh",  "<cmd>Telescope help_tags<CR>",                                          desc = "Help Tags" },
            { "<leader>fs",  "<cmd>Telescope treesitter<CR>",                                         desc = "Show Functions" },

            { "<leader>r",   group = "Run" },
            { "<leader>rc",  "<cmd>source $MYVIMRC<CR>",                                              desc = "Reload Config" },

            { "<leader>G",   group = "Gitsigns" },
            { "<leader>Gs",  "<cmd>Gitsigns stage_hunk<CR>",                                          desc = "Stage Hunk" },
            { "<leader>Gu",  "<cmd>Gitsigns undo_stage_hunk<CR>",                                     desc = "Undo Stage Hunk" },
            { "<leader>Gr",  "<cmd>Gitsigns reset_hunk<CR>",                                          desc = "Reset Hunk" },
            { "<leader>Gp",  "<cmd>Gitsigns preview_hunk<CR>",                                        desc = "Preview Hunk" },
            { "<leader>Gb",  "<cmd>Gitsigns blame_line<CR>",                                          desc = "Blame Line" },

            -- Non-leader keymaps
            { "[c",          "<cmd>Gitsigns prev_hunk<CR>",                                           desc = "Previous Git Hunk" },
            { "]c",          "<cmd>Gitsigns next_hunk<CR>",                                           desc = "Next Git Hunk" },
        })
    end,
}
