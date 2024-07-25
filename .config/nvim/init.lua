--     catpuccin
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

-- Source .vimrc for backward compatibility
vim.cmd('source ~/.vimrc')

-- Lazy package manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then -- type: ignore
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

-- Initialize lazy.nvim
require("lazy").setup("plugins", {})

-- Theme application function
function _G.apply_theme(theme)
    vim.o.background = "dark"
    vim.opt.termguicolors = true
    local colorscheme = theme
    local lualine_theme = theme

    -- if theme == "tokyonight" then
    --     colorscheme = "tokyonight-night"
    --     -- lualine_theme remains "tokyonight"
    -- end

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

-- End of init.lua
