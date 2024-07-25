-- Treesitter - https://github.com/nvim-treesitter/nvim-treesitter
return {
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
}
