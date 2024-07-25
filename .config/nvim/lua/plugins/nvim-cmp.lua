-- CMP - completion engine - https://github.com/hrsh7th/nvim-cmp
return {
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
}
