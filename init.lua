local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
config_path = vim.fn.stdpath('config')
package.path = package.path .. ";" .. config_path .. "/?.lua;" .. config_path .. "/?/init.lua;" .. config_path .. "/plugins/?.lua;" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;" .. vim.fn.expand("$HOME").. "/.luarocks/share/lua/5.1/?.lua;"
vim.g.mapleader = " "
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

vim.g.suda_smart_edit = 1

require("lazy").setup({
    {import = "plugins"},
    "lambdalisue/suda.vim",
    "doums/darcula",
    "tpope/vim-fugitive",
    "tpope/vim-speeddating",
    'mhinz/vim-startify',
    "ryanoasis/vim-devicons",
    {"lukas-reineke/indent-blankline.nvim",
    config= function ()

        require("ibl").setup { indent = {char = {"▏"}} }
    end},
    'mbbill/undotree',
    "nvim-lua/plenary.nvim",
    { 'rose-pine/neovim', name = 'rose-pine' },
    "preservim/tagbar",

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys={
            {"<leader>xq", "<cmd>TroubleToggle quickfix<cr>",desc="Toggle quickfix"},
            {"<leader>tq", "<cmd>TroubleToggle<cr>",desc="Toggle trouble"}
        },
        opts = {
        },
    },
    performance = {
        rtp = {
            paths = { "~/.config/nvim/snippets" }
        }
    }
})

require('settings/remap') -- personal keymappings
require('settings/general') -- settings

vim.cmd('colorscheme rose-pine')
